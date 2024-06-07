#!/bin/sh
set -e

# Install jq and coreutils if they are not already installed
if ! apk list --installed | grep -q jq; then
    apk add --no-cache jq
    JQ_INSTALLED=1
else
    JQ_INSTALLED=0
fi

if ! apk list --installed | grep -q coreutils; then
    apk add --no-cache coreutils
    CU_INSTALLED=1
else
    CU_INSTALLED=0
fi

# Create the /root/.vscode-server/data/Machine/ directory if it does not exist
mkdir -p /root/.vscode-server/data/Machine/

# Create the /root/.vscode-server/data/Machine/settings.json if it does not exist
touch /root/.vscode-server/data/Machine/settings.json

# Set the "terminal.integrated.defaultProfile.linux" setting to "sh" in the settings.json
tmp=$(mktemp)
jq '. + {"terminal.integrated.defaultProfile.linux": "sh"}' /root/.vscode-server/data/Machine/settings.json > "$tmp"
mv "$tmp" /root/.vscode-server/data/Machine/settings.json

# Set the "terminal.integrated.profiles.linux"/"sh"/"path" property to "/bin/sh" in the settings.json
tmp=$(mktemp)
jq '. + {"terminal.integrated.profiles.linux": {"sh": {"path": "/bin/sh"}}}' /root/.vscode-server/data/Machine/settings.json > "$tmp"
mv "$tmp" /root/.vscode-server/data/Machine/settings.json

# Set the "terminal.integrated.profiles.linux"/"sh"/"args" property to ["-l"] in the settings.json
tmp=$(mktemp)
jq '. + {"terminal.integrated.profiles.linux": {"sh": {"args": ["-l"]}}}' /root/.vscode-server/data/Machine/settings.json > "$tmp"
mv "$tmp" /root/.vscode-server/data/Machine/settings.json


# Clean up
if [ "$JQ_INSTALLED" -eq 1 ]; then
    apk del jq
fi

if [ "$CU_INSTALLED" -eq 1 ]; then
    apk del coreutils
fi