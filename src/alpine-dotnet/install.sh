#!/usr/bin/env bash

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

# Download the install script
echo "Downloading dotnet-install.sh..."
wget -q https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh

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
. ./dotnet-install.sh $INSTALL_ARGS

# Clean up
rm -f dotnet-install.sh

echo "Done!"