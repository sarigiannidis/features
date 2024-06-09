#!/bin/sh
set -e

# Install bash
apk add --no-cache --upgrade bash

# --- Generate an 'update-vscode-server-settings.sh' script to be executed by the 'postCreateCommand' lifecycle hook
UPDATE_VSCODE_SERVER_SETTINGS_SCRIPT_PATH="/usr/local/share/update-vscode-server-settings.sh"

tee "$UPDATE_VSCODE_SERVER_SETTINGS_SCRIPT_PATH" > /dev/null \
<< EOF
#!/bin/sh
set -e

# Install jq and coreutils if they are not already installed
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

MACHINE_PATH="/root/.vscode-server/data/Machine"
SETTINGS_FILE="\${MACHINE_PATH}/settings.json"

# Create the /root/.vscode-server/data/Machine/ directory if it does not exist
mkdir -p \$MACHINE_PATH

# if the \$SETTINGS_FILE does not exist, create it and add the following content:"{}"
if [ ! -f \$SETTINGS_FILE ] || [ ! -s \$SETTINGS_FILE ]; then
    echo "{}" > \$SETTINGS_FILE
fi

# Set the "terminal.integrated.defaultProfile.linux" setting to "bash" in the settings.json
tmp=\$(mktemp)
jq '."terminal.integrated.defaultProfile.linux" = "bash"' \$SETTINGS_FILE > "\$tmp"
mv "\$tmp" \$SETTINGS_FILE

# Set the "terminal.integrated.profiles.linux"/"sh"/"path" property to "/bin/bash" in the settings.json
tmp=\$(mktemp)
jq '."terminal.integrated.profiles.linux".sh.path = "/bin/bash"' \$SETTINGS_FILE > "\$tmp"
mv "\$tmp" \$SETTINGS_FILE

# "terminal.integrated.profiles.linux"/"sh"/"args" is an array property. Append "-l" to the array in the without removing other values from the array
tmp=\$(mktemp)
jq '."terminal.integrated.profiles.linux".sh.args |= . + ["-l"]' \$SETTINGS_FILE > "\$tmp"
mv "\$tmp" \$SETTINGS_FILE

# Clean up
if [ "\$JQ_INSTALLED" -eq 1 ]; then
    apk del --quiet jq
fi

if [ "\$CU_INSTALLED" -eq 1 ]; then
    apk del --quiet coreutils
fi

EOF

chmod 755 "$UPDATE_VSCODE_SERVER_SETTINGS_SCRIPT_PATH"

echo "Done!"