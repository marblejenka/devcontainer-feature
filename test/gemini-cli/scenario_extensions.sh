#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

# Check if conductor extension is installed
# The conductor extension usually registers a command or can be seen in 'gemini extensions list'
check "gemini extensions list" gemini extensions list | grep -i "conductor"

# Report results
reportResults
