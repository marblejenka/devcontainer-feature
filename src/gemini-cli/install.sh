#!/usr/bin/env bash

GEMINI_CLI_VERSION="${VERSION:-"latest"}"

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# install gemini cli
if [ "$GEMINI_CLI_VERSION" = "latest" ]; then
    npm install -g @google/gemini-cli
else
    npm install -g @google/gemini-cli@${GEMINI_CLI_VERSION}
fi
