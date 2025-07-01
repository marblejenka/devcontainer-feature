#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json.
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
#    "features": {
#      "gemini-cli": {}
#    }
# }
#
# This test can be run with the following command:
#
# devcontainer features test                 \
#                    --features gemini-cli   \
#                    --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#                    .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "gemini command should exist" command -v gemini
check "gemini version" gemini --version

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
