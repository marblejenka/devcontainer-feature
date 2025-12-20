#!/bin/bash
set -e
source dev-container-features-test-lib
# Check for the existence of the cloned install.sh from geminifiles repo
check "geminifiles repository was cloned" test -f /tmp/gemini-geminifiles/install.sh
reportResults
