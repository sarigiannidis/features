#!/bin/sh
# ============================================================================
# Alpine Bash Feature Installation Script
# ============================================================================
# Installs Bash shell as an alternative to Alpine's default ash shell on Alpine Linux.
# Also configures VS Code Server to use Bash as the default terminal.
#
# What this script does:
# 1. Installs Bash shell package
# 2. Creates a VS Code Server settings update script
# 3. Configures VS Code to use Bash as default terminal
# ============================================================================

set -e

echo "Activating feature 'alpine-bash'"

# Install bash shell as an alternative to Alpine's default ash shell
# --no-cache prevents caching to keep image size small
# --upgrade ensures we get the latest version
apk add --no-cache --upgrade bash

# --- Generate an 'update-vscode-server-settings.sh' script to be executed by the 'postCreateCommand' lifecycle hook
UPDATE_VSCODE_SERVER_SETTINGS_SCRIPT_PATH="/usr/local/share/update-vscode-server-settings.sh"

# Create a script that will configure VS Code Server settings to use Bash
# This script will be executed after the container is created
tee "$UPDATE_VSCODE_SERVER_SETTINGS_SCRIPT_PATH" > /dev/null \
<< EOF
#!/bin/sh
# VS Code Server Settings Update Script
# Configures VS Code to use Bash as the default terminal shell
set -e

# Install jq and coreutils if they are not already installed
# These tools are needed to modify JSON settings files
if ! apk list --installed | grep -q jq; then
    apk add --no-cache --quiet jq
    JQ_INSTALLED=1
else
    JQ_INSTALLED=0
fi

if ! apk list --installed | grep -q coreutils; then
    apk add --no-cache --quiet coreutils
    CU_INSTALLED=1
else
    CU_INSTALLED=0
fi

# VS Code Server configuration paths
MACHINE_PATH="/root/.vscode-server/data/Machine"
SETTINGS_FILE="\${MACHINE_PATH}/settings.json"

# Create the VS Code Server Machine directory if it does not exist
mkdir -p \$MACHINE_PATH

# Create an empty settings file if it doesn't exist or is empty
if [ ! -f \$SETTINGS_FILE ] || [ ! -s \$SETTINGS_FILE ]; then
    echo "{}" > \$SETTINGS_FILE
fi

# Configure terminal settings to use Bash as default
# Set the default terminal profile to "bash"
tmp=\$(mktemp)
jq '."terminal.integrated.defaultProfile.linux" = "bash"' \$SETTINGS_FILE > "\$tmp"
mv "\$tmp" \$SETTINGS_FILE

# Configure the sh profile to use bash executable
tmp=\$(mktemp)
jq '."terminal.integrated.profiles.linux".sh.path = "/bin/bash"' \$SETTINGS_FILE > "\$tmp"
mv "\$tmp" \$SETTINGS_FILE

# Add login shell argument to ensure proper environment loading
tmp=\$(mktemp)
jq '."terminal.integrated.profiles.linux".sh.args |= . + ["-l"]' \$SETTINGS_FILE > "\$tmp"
mv "\$tmp" \$SETTINGS_FILE

# Clean up temporary tools if we installed them
if [ "\$JQ_INSTALLED" -eq 1 ]; then
    apk del --quiet jq
fi

if [ "\$CU_INSTALLED" -eq 1 ]; then
    apk del --quiet coreutils
fi

EOF

# Make the VS Code settings update script executable
chmod 755 "$UPDATE_VSCODE_SERVER_SETTINGS_SCRIPT_PATH"

echo "Feature 'alpine-bash' installed successfully"