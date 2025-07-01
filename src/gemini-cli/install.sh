#!/usr/bin/env bash

GEMINI_VERSION="${VERSION:-"latest"}"
INSTALL_NPM="${INSTALLNPM:-"false"}"
NPM_VERSION="${NPMVERSION:-"latest"}"

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# check npm installed
if [ "$INSTALL_NPM" = "true" ]; then
    if ! type npm > /dev/null; then
        echo "Installing npm..."
        if [ "$NPM_VERSION" = "latest" ]; then
            npm_install_cmd="npm install -g npm"
        else
            npm_install_cmd="npm install -g npm@${NPM_VERSION}"
        fi
        eval "$npm_install_cmd"
    else
        echo "npm is already installed."
    fi
fi

# halt if npm is not found
if ! type npm > /dev/null; then
    echo "npm is required but not installed. Please set INSTALLNPM to true or install npm manually."
    exit 1
fi

# install gemini cli
if [ "$GEMINI_VERSION" = "latest" ]; then
    npm install -g @google/gemini-cli
else
    npm install -g @google/gemini-cli@${GEMINI_VERSION}
fi
