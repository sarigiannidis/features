#!/bin/sh
set -e

apk add --no-cache \
    coreutils \
    jq    

# Create the /root/.vscode-server/data/Machine/ directory if it does not exist
mkdir -p /root/.vscode-server/data/Machine/

# Create the /root/.vscode-server/data/Machine/settings.json if it does not exist
touch /root/.vscode-server/data/Machine/settings.json

# Do not overwrite any other settings that may be in the settings.json file

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

# Copy the settings.json file to /root/.vscode-server/data/Machine/settings.json
# cp settings.json /root/.vscode-server/data/Machine/settings.json