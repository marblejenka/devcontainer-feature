#!/usr/bin/env bash

GEMINI_CLI_VERSION=${VERSION:-latest}
GEMINIFILES=${GEMINIFILES:-""}
KEEP_GOOGLE_API_CREDENTIALS=${KEEP_GOOGLE_API_CREDENTIALS:-false}
GOOGLE_API_CREDENTIALS_PERSIST_DIR=${GOOGLE_API_CREDENTIALS_PERSIST_DIR:-"/dc/gemini-cli"}
EXTENSIONS=${EXTENSIONS:-""}

set -e

GEMINI_USER=${_REMOTE_USER:-"${_CONTAINER_USER:-${SUDO_USER:-root}}"}
GEMINI_GROUP=$(id -gn "${GEMINI_USER}" 2>/dev/null || echo "${GEMINI_USER}")


if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Resolve user's home directory
GEMINI_HOME=$(getent passwd "${GEMINI_USER}" | cut -d: -f6)
if [ -z "${GEMINI_HOME}" ]; then
    if [ "${GEMINI_USER}" = "root" ]; then
        GEMINI_HOME="/root"
    else
        GEMINI_HOME="/home/${GEMINI_USER}"
    fi
fi

# Set configuration directory based on user
GEMINI_CONFIG_DIR=${GEMINI_CONFIG_DIR:-"${GEMINI_HOME}/.gemini"}

# install gemini cli
if [ "$GEMINI_CLI_VERSION" = "latest" ]; then
    npm install -g @google/gemini-cli@latest
else
    npm install -g @google/gemini-cli@${GEMINI_CLI_VERSION}
fi

hash -r

# Helper to change ownership if user exists
chk_chown() {
    local user="$1"
    local group="$2"
    local target="$3"
    local recursive="$4"

    if [ -e "$target" ]; then
        if id -u "$user" > /dev/null 2>&1; then
            if [ "$recursive" = "true" ]; then
                chown -R "$user:$group" "$target"
            else
                chown "$user:$group" "$target"
            fi
        else
            echo "User $user does not exist, skipping chown for $target."
        fi
    fi
}

# setup .gemini files if GEMINIFILES is provided
if [ -n "$GEMINIFILES" ]; then
    GEMINIFILES_REPO=${GEMINIFILES_REPO:-"${GEMINI_HOME}/geminifiles"}

    echo "Cloning geminifiles repository from $GEMINIFILES for ${GEMINI_USER}."
    echo "Repo: ${GEMINIFILES_REPO}"
    echo "Destination: ${GEMINI_CONFIG_DIR}"

    git clone "$GEMINIFILES" ${GEMINIFILES_REPO}

    chk_chown "${GEMINI_USER}" "${GEMINI_GROUP}" "${GEMINIFILES_REPO}" "true"

    if [ -f "${GEMINIFILES_REPO}/install.sh" ]; then
        echo "Found install.sh in the geminifiles repository, running it."
        chmod +x ${GEMINIFILES_REPO}/install.sh
        GEMINIFILES_DST="$GEMINI_CONFIG_DIR" ${GEMINIFILES_REPO}/install.sh
        chk_chown "${GEMINI_USER}" "${GEMINI_GROUP}" "${GEMINI_CONFIG_DIR}" "true"
    else
        echo "No install.sh found in the geminifiles repository."
    fi
else
    echo "No geminifiles repository specified, skipping cloning and installation."
fi

# Handle Google API credentials persistence if enabled
if [ "$KEEP_GOOGLE_API_CREDENTIALS" = "true" ]; then

    # Restrict the credentials persist directory to a safe base path
    SAFE_BASE_DIR="/dc/gemini-cli"
    SAFE_BASE_REALPATH=$(readlink -f "${SAFE_BASE_DIR}" 2>/dev/null || echo "${SAFE_BASE_DIR}")
    PERSIST_REALPATH=$(readlink -f "${GOOGLE_API_CREDENTIALS_PERSIST_DIR}" 2>/dev/null || echo "${GOOGLE_API_CREDENTIALS_PERSIST_DIR}")

    case "${PERSIST_REALPATH}" in
        "${SAFE_BASE_REALPATH}"|"${SAFE_BASE_REALPATH}"/*)
            # Allowed: within SAFE_BASE_DIR
            ;;
        *)
            echo "Error: GOOGLE_API_CREDENTIALS_PERSIST_DIR must be under ${SAFE_BASE_REALPATH}. Current: ${GOOGLE_API_CREDENTIALS_PERSIST_DIR}"
            exit 1
            ;;
    esac

    # If the directory already exists, ensure it does not contain unexpected files
    if [ -d "${GOOGLE_API_CREDENTIALS_PERSIST_DIR}" ]; then
        shopt -s nullglob
        unexpected_files=()
        for entry in "${GOOGLE_API_CREDENTIALS_PERSIST_DIR}"/*; do
            base_entry=$(basename "${entry}")
            if [ "${base_entry}" != "oauth_creds.json" ] && [ "${base_entry}" != ".gitignore" ]; then
                unexpected_files+=("${entry}")
            fi
        done
        shopt -u nullglob

        if [ "${#unexpected_files[@]}" -ne 0 ]; then
            echo "Error: GOOGLE_API_CREDENTIALS_PERSIST_DIR contains unexpected files:"
            for f in "${unexpected_files[@]}"; do
                echo "  - ${f}"
            done
            echo "Please choose an empty directory or one containing only oauth_creds.json and/or .gitignore."
            exit 1
        fi
    fi

    # Ensure the target user exists before creating a directory that will be owned by it
    if ! id -u "${GEMINI_USER}" >/dev/null 2>&1; then
        echo "Error: GEMINI_USER '${GEMINI_USER}' does not exist. Cannot set ownership for GOOGLE_API_CREDENTIALS_PERSIST_DIR."
        exit 1
    fi
    mkdir -p "${GOOGLE_API_CREDENTIALS_PERSIST_DIR}"
    # Change ownership only on the credentials directory itself, not recursively
    chk_chown "${GEMINI_USER}" "${GEMINI_GROUP}" "${GOOGLE_API_CREDENTIALS_PERSIST_DIR}"

    # Ensure GEMINI_CONFIG_DIR exists; only create and change ownership if it does not already exist
    if [ ! -d "${GEMINI_CONFIG_DIR}" ]; then
        mkdir -p "${GEMINI_CONFIG_DIR}"
        chk_chown "${GEMINI_USER}" "${GEMINI_GROUP}" "${GEMINI_CONFIG_DIR}"
    fi

    # Create symbolic link for authentication file
    # Place the actual file in the volume and link it from ~/.gemini/oauth_creds.json
    AUTH_FILE="${GEMINI_CONFIG_DIR}/oauth_creds.json"
    PERSIST_AUTH_FILE="${GOOGLE_API_CREDENTIALS_PERSIST_DIR}/oauth_creds.json"

    # Create an empty file in the volume if it doesn't exist (to prevent permission errors)
    if [ ! -f "${PERSIST_AUTH_FILE}" ]; then
        touch "${PERSIST_AUTH_FILE}"
    fi

    # Ensure persisted auth file has correct permissions and ownership
    # Set permissions to 600 (owner read/write) to match gemini-cli specifications
    chmod 600 "${PERSIST_AUTH_FILE}"
    chk_chown "${GEMINI_USER}" "${GEMINI_GROUP}" "${PERSIST_AUTH_FILE}"
    # Delete existing file or old link in ~/.gemini and recreate the link
    rm -f "${AUTH_FILE}"
    ln -s "${PERSIST_AUTH_FILE}" "${AUTH_FILE}"
    # Use chown -h to change ownership of the symlink itself; chk_chown does not support -h
    chown -h "${GEMINI_USER}:${GEMINI_GROUP}" "${AUTH_FILE}"

    echo "Persistence link created: ${AUTH_FILE} -> ${PERSIST_AUTH_FILE}"
else
    echo "Google API credentials persistence not enabled, skipping."
fi

# Install Gemini CLI extensions if provided
if [ -n "${EXTENSIONS}" ]; then
    echo "Installing Gemini CLI extensions: ${EXTENSIONS}"
    
    # Get the absolute path of the gemini executable
    # Prioritize npm global prefix
    NPM_GLOBAL_PREFIX=$(npm config get prefix -g)
    if [ -x "${NPM_GLOBAL_PREFIX}/bin/gemini" ]; then
        GEMINI_BIN="${NPM_GLOBAL_PREFIX}/bin/gemini"
    else
        GEMINI_BIN=$(command -v gemini 2>/dev/null || echo "/usr/local/bin/gemini")
    fi

    # Verify that the resolved gemini binary is executable
    if [ ! -x "${GEMINI_BIN}" ]; then
        echo "Error: gemini binary not found or not executable at ${GEMINI_BIN}"
        exit 1
    fi
    # Verify that GEMINI_BIN is an executable before proceeding
    if [ ! -x "${GEMINI_BIN}" ]; then
        echo "Error: gemini CLI binary not found or not executable (tried: ${GEMINI_BIN})." >&2
        echo "       Ensure the gemini CLI is installed and available in PATH before installing extensions." >&2
        exit 1
    fi
    # Use comma as delimiter to split the extensions string
    IFS=',' read -ra EXT_LIST <<< "${EXTENSIONS}"
    for ext in "${EXT_LIST[@]}"; do
        # Trim whitespace
        ext=$(echo "${ext}" | xargs)
        if [ -n "${ext}" ]; then
            # Validate extension name to avoid shell injection via EXTENSIONS
            if ! printf '%s\n' "${ext}" | grep -Eq '^[A-Za-z0-9_.:-]+$'; then
                echo "Skipping invalid extension name (contains unsafe characters): ${ext}"
                continue
            fi

            echo "Installing extension: ${ext} for ${GEMINI_USER}"
            # Run as GEMINI_USER to ensure extensions are installed in their home directory
            # We ensure PATH is preserved and common paths are included
            # Pass the extension name via an environment variable to avoid injecting into the shell command
            GEMINI_EXTENSION_NAME="${ext}" \
            su "${GEMINI_USER}" -c "PATH=$PATH:/usr/local/bin:/usr/bin \"${GEMINI_BIN}\" extensions install \"\${GEMINI_EXTENSION_NAME}\""
        fi
    done
fi

