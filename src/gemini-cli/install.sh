#!/usr/bin/env bash

GEMINI_CLI_VERSION=${VERSION:-latest}
CONFIG=${CONFIG:-""}

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

if [ -n "$CONFIG" ]; then
    echo "Cloning config repository from $CONFIG"
    git clone "$CONFIG" /tmp/gemini-config
    if [ -f "/tmp/gemini-config/install.sh" ]; then
        echo "Found install.sh in the config repository, running it."
        chmod +x /tmp/gemini-config/install.sh
        /tmp/gemini-config/install.sh
    else
        echo "No install.sh found in the config repository."
    fi
fi
