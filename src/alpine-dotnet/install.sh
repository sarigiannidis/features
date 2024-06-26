#!/usr/bin/env bash

set -ex

# Read the options
O_ARCHITECTURE="${ARCHITECTURE:-"<auto>"}"
O_CHANNEL="${CHANNEL:-"<LTS>"}"
O_QUALITY="${QUALITY:-"GA"}"
O_RUNTIME="${RUNTIME:-"dotnet"}"
O_VERSION=$VERSION

# Download the install script
wget -q https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh

# Make the script executable
chmod +x dotnet-install.sh

# TODO
# 1. Use the options to install the .NET SDK
# 2. GPG: https://learn.microsoft.com/en-gb/dotnet/core/tools/dotnet-install-script?WT.mc_id=dotnet-35129-website#preparing-environment

. ./dotnet-install.sh --channel 9.0.1xx --quality preview --install-dir /usr/local/share/dotnet