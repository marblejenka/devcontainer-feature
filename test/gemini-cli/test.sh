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

check "gemini scaffold devcontainer-feature" bash -c "
    set -e
    TEMP_DIR=\$(mktemp -d)
    cd \$TEMP_DIR
    gemini scaffold devcontainer-feature test-feature
    test -f test-feature/GEMINI.md
    test -f test-feature/README.md
    test -f test-feature/devcontainer-feature.json
    test -f test-feature/install.sh
    test -f test-feature/NOTES.md
"

check "gemini with geminifiles" bash -c "
    set -e
    export GEMINIFILES=https://github.com/marblejenka/geminifiles.git
    sudo /workspaces/devcontainer-feature/src/gemini-cli/install.sh
    test -f /tmp/gemini-gemnifiles/README.md
"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
