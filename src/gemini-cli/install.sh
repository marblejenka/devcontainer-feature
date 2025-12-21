#!/usr/bin/env bash

GEMINI_CLI_VERSION=${VERSION:-latest}
GEMINIFILES=${GEMINIFILES:-""}

_REMOTE_USER=${_REMOTE_USER:-"${USER}"}
GEMINIFILES_REPO_DEST=${GEMINIFILES_REPO_DEST:-"/home/${_REMOTE_USER}/geminifiles"}
GEMINI_CONFIG_DIR=${GEMINI_CONFIG_DIR:-"/home/${_REMOTE_USER}/.gemini"}

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
    echo "Cloning geminifiles repository from $GEMINIFILES"
    git clone "$GEMINIFILES" ${GEMINIFILES_REPO_DEST}
    if [ -f "${GEMINIFILES_REPO_DEST}/install.sh" ]; then
        echo "Found install.sh in the geminifiles repository, running it."
        chmod +x ${GEMINIFILES_REPO_DEST}/install.sh
        GEMINIFILES_DST="$GEMINI_CONFIG_DIR" ${GEMINIFILES_REPO_DEST}/install.sh
        if [ -d "$GEMINI_CONFIG_DIR" ]; then
            chown -R "${_REMOTE_USER}:${_REMOTE_USER}" "$GEMINI_CONFIG_DIR"
        fi
    else
        echo "No install.sh found in the geminifiles repository."
    fi
else
    echo "No geminifiles repository specified, skipping cloning and installation."
fi
