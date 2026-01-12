#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

# Check if gemini command is available
check "gemini --version" gemini --version

# Debug info
echo "Current user: $(whoami)"
gemini extensions list || echo "Debug: 'gemini extensions list' failed (non-fatal)."

# Check if conductor extension is installed
# The conductor extension usually registers a command or can be seen in 'gemini extensions list'
check "conductor extension installed" bash -c "gemini extensions list | grep -i 'conductor'"

# Report results
reportResults
