#!/bin/sh
set -e

# Create the /root/.vscode-server/data/Machine/ directory if it does not exist
mkdir -p /root/.vscode-server/data/Machine/

# Create the /root/.vscode-server/data/Machine/settings.json if it does not exist
touch /root/.vscode-server/data/Machine/settings.json

# Set the "terminal.integrated.defaultProfile.linux" setting to "sh" in the settings.json
echo '{"terminal.integrated.defaultProfile.linux": "sh"}' > settings.json

# Copy the settings.json file to /root/.vscode-server/data/Machine/settings.json
cp settings.json /root/.vscode-server/data/Machine/settings.json