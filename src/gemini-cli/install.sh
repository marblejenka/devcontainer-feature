#!/usr/bin/env bash

GEMINI_VERSION="${VERSION:-"latest"}"
INSTALL_NPM="${INSTALLNPM:-"false"}"
NPM_VERSION="${NPMVERSION:-"latest"}"

set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

