#!/usr/bin/env bash

GEMINI_CLI_VERSION=${VERSION:-latest}
GEMINIFILES=${GEMINIFILES:-""}

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# install gemini cli
if [ "$GEMINI_CLI_VERSION" = "latest" ]; then
    npm install -g @google/gemini-cli@latest
else
    npm install -g @google/gemini-cli@${GEMINI_CLI_VERSION}
fi

if [ -n "$GEMINIFILES" ]; then
    GEMINI_USER=${_REMOTE_USER:-"${_CONTAINER_USER:-${SUDO_USER:-root}}"}

    if [ "$GEMINI_USER" = "root" ]; then
        GEMINIFILES_REPO=${GEMINIFILES_REPO:-"/root/geminifiles"}
        GEMINI_CONFIG_DIR=${GEMINI_CONFIG_DIR:-"/root/.gemini"}
    else
        GEMINIFILES_REPO=${GEMINIFILES_REPO:-"/home/${GEMINI_USER}/geminifiles"}
        GEMINI_CONFIG_DIR=${GEMINI_CONFIG_DIR:-"/home/${GEMINI_USER}/.gemini"}
    fi

    echo "Cloning geminifiles repository from $GEMINIFILES for ${GEMINI_USER}."
    echo "Repo: ${GEMINIFILES_REPO}"
    echo "Destination: ${GEMINI_CONFIG_DIR}"

    git clone "$GEMINIFILES" ${GEMINIFILES_REPO}

    if [ -f "${GEMINIFILES_REPO}/install.sh" ]; then
        echo "Found install.sh in the geminifiles repository, running it."
        chmod +x ${GEMINIFILES_REPO}/install.sh
        GEMINIFILES_DST="$GEMINI_CONFIG_DIR" ${GEMINIFILES_REPO}/install.sh
        if [ -d "$GEMINI_CONFIG_DIR" ]; then
            chown -R "${GEMINI_USER}:${GEMINI_USER}" "$GEMINI_CONFIG_DIR"
        fi
    else
        echo "No install.sh found in the geminifiles repository."
    fi
else
    echo "No geminifiles repository specified, skipping cloning and installation."
fi
