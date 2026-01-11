#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json.
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "mcr.microsoft.com/devcontainers/base:ubuntu",
#    "features": {
#      "tlaplus": {}
#    }
# }
#
# This test can be run with the following command:
#
# devcontainer features test                 \
#                    --features tlaplus   \
#                    --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#                    .

set -e

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.
check "java command should exist" command -v java
check "tla2tools.jar should exist" test -f /tlaplus/tla2tools.jar
check "CommunityModules-deps.jar should exist" test -f /tlaplus/CommunityModules-deps.jar
check "apalache.jar should exist" test -f /tlaplus/apalache/lib/apalache.jar

check "tlcrepl command should exist" command -v tlcrepl
check "tlc command should exist" command -v tlc
check "sany command should exist" command -v sany
check "pcal command should exist" command -v pcal
check "tla2tex command should exist" command -v tla2tex

check "tlapm command should exist" command -v tlapm
check "tlapm_lsp command should exist" command -v tlapm_lsp
check "translate command should exist" command -v translate

check "apalache-mc command should exist" command -v apalache-mc
check "tlauc command should exist" command -v tlauc

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
