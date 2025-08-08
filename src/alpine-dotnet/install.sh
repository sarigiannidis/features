#!/usr/bin/env bash

# NOTE: This script MUST use bash, not sh!
# The Microsoft dotnet-install.sh script that we download requires bash.
# Do not change the shebang to #!/bin/sh as it will break the installation.

set -ex

# Read the options
O_ARCHITECTURE="${ARCHITECTURE:-"<auto>"}"
O_CHANNEL="${CHANNEL:-"LTS"}"
O_QUALITY="${QUALITY:-"GA"}"
O_RUNTIME="${RUNTIME:-"dotnet"}"
O_VERSION="${VERSION:-"latest"}"

echo "Activating feature 'alpine-dotnet'"
echo "Architecture: $O_ARCHITECTURE"
echo "Channel: $O_CHANNEL"
echo "Quality: $O_QUALITY"
echo "Runtime: $O_RUNTIME"
echo "Version: $O_VERSION"

# Create temporary directory for downloads
TEMP_DIR=$(mktemp -d)
cd "$TEMP_DIR"

# Download the install script
echo "Downloading dotnet-install.sh..."
wget -q https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh

# Verify the script is reasonable size (basic sanity check)
SCRIPT_SIZE=$(wc -c < dotnet-install.sh)
if [ "$SCRIPT_SIZE" -lt 1000 ] || [ "$SCRIPT_SIZE" -gt 100000 ]; then
    echo "ERROR: Downloaded script size ($SCRIPT_SIZE bytes) is suspicious"
    exit 1
fi

# Basic content verification - check for expected patterns
if ! grep -q "Microsoft Corporation" dotnet-install.sh; then
    echo "ERROR: Downloaded script doesn't appear to be from Microsoft"
    exit 1
fi

# Additional security checks
if grep -q "rm -rf /" dotnet-install.sh || grep -q "curl.*|.*sh" dotnet-install.sh; then
    echo "ERROR: Downloaded script contains suspicious commands"
    exit 1
fi

# Verify script contains expected functions
if ! grep -q "get_normalized_architecture_for_current_os" dotnet-install.sh; then
    echo "ERROR: Downloaded script doesn't contain expected .NET installer functions"
    exit 1
fi

# Make the script executable
chmod +x dotnet-install.sh

# Build the install command with the provided options
INSTALL_ARGS="--install-dir /usr/local/share/dotnet"

if [ "$O_ARCHITECTURE" != "<auto>" ]; then
    INSTALL_ARGS="$INSTALL_ARGS --architecture $O_ARCHITECTURE"
fi

if [ "$O_CHANNEL" != "" ]; then
    INSTALL_ARGS="$INSTALL_ARGS --channel $O_CHANNEL"
fi

if [ "$O_QUALITY" != "" ]; then
    INSTALL_ARGS="$INSTALL_ARGS --quality $O_QUALITY"
fi

if [ "$O_RUNTIME" != "dotnet" ]; then
    INSTALL_ARGS="$INSTALL_ARGS --runtime $O_RUNTIME"
fi

if [ "$O_VERSION" != "latest" ]; then
    INSTALL_ARGS="$INSTALL_ARGS --version $O_VERSION"
fi

echo "Installing .NET with args: $INSTALL_ARGS"

# Execute the install script with the configured options
. ./dotnet-install.sh "$INSTALL_ARGS"

# Clean up
cd /
rm -rf "$TEMP_DIR"

echo "Done!"