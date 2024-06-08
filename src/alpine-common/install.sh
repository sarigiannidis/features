#!/bin/sh
set -e

# --- Generate an 'update-vscode-server-settings.sh' script to be executed by the 'postCreateCommand' lifecycle hook
UPDATE_VSCODE_SERVER_SETTINGS_SCRIPT_PATH="/usr/local/share/update-vscode-server-settings.sh"

tee "$UPDATE_VSCODE_SERVER_SETTINGS_SCRIPT_PATH" > /dev/null \
<< EOF
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

MACHINE_PATH="/root/.vscode-server/data/Machine"
SETTINGS_FILE="\${MACHINE_PATH}/settings.json"

# Create the /root/.vscode-server/data/Machine/ directory if it does not exist
mkdir -p \$MACHINE_PATH

# Create the \$SETTINGS_FILE if it does not exist
touch \$MACHINE_PATH/settings.json

# Set the "terminal.integrated.defaultProfile.linux" setting to "sh" in the settings.json
tmp=\$(mktemp)
jq '."terminal.integrated.defaultProfile.linux" = "sh"' \$SETTINGS_FILE > "\$tmp"
mv "\$tmp" \$SETTINGS_FILE

# Set the "terminal.integrated.profiles.linux"/"sh"/"path" property to "/bin/sh" in the settings.json
tmp=\$(mktemp)
jq '."terminal.integrated.profiles.linux".sh.path = "/bin/sh"' \$SETTINGS_FILE > "\$tmp"
mv "\$tmp" \$SETTINGS_FILE

# "terminal.integrated.profiles.linux"/"sh"/"args" is an array property. Append "-l" to the array in the without removing other values from the array
tmp=\$(mktemp)
jq '."terminal.integrated.profiles.linux".sh.args |= . + ["-l"]' \$SETTINGS_FILE > "\$tmp"
mv "\$tmp" \$SETTINGS_FILE

# Clean up
if [ "\$JQ_INSTALLED" -eq 1 ]; then
    apk del jq
fi

if [ "\$CU_INSTALLED" -eq 1 ]; then
    apk del coreutils
fi

EOF

chmod 755 "$UPDATE_VSCODE_SERVER_SETTINGS_SCRIPT_PATH"

echo "Done!"