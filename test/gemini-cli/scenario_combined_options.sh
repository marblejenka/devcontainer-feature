#!/bin/bash
set -e
source dev-container-features-test-lib

# Check for the existence of the cloned install.sh from geminifiles repo
check "geminifiles repository was cloned" test -f $HOME/geminifiles/install.sh

# Check for the existence of the persistence directory
check "persistence directory exists" test -d /dc/gemini-cli

# Check if ~/.gemini/oauth_creds.json is a symlink pointing to /dc/gemini-cli/oauth_creds.json
check "oauth_creds.json is a symlink" test -L $HOME/.gemini/oauth_creds.json
check "oauth_creds.json points to persistence directory" [ "$(readlink $HOME/.gemini/oauth_creds.json)" = "/dc/gemini-cli/oauth_creds.json" ]

reportResults
