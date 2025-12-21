#!/bin/bash
set -e
source dev-container-features-test-lib
check "settings.json exists" test -f /home/node/.gemini/settings.json
reportResults
