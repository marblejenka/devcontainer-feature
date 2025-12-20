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
    echo "Cloning geminifiles repository from $GEMINIFILES"
    git clone "$GEMINIFILES" /tmp/gemini-geminifiles
    if [ -f "/tmp/gemini-geminifiles/install.sh" ]; then
        echo "Found install.sh in the geminifiles repository, running it."
        chmod +x /tmp/gemini-geminifiles/install.sh
        /tmp/gemini-geminifiles/install.sh
    else
        echo "No install.sh found in the geminifiles repository."
    fi
fi
