#!/usr/bin/env bash

curl -s -O https://dotnet.microsoft.com/download/dotnet/scripts/v1/dotnet-install.sh
chmod +x dotnet-install.sh

# TODO
# 1. Add support for installing specific version of .NET Core SDK (options in devcontainer-feature.json)
# 2. GPG: https://learn.microsoft.com/en-gb/dotnet/core/tools/dotnet-install-script?WT.mc_id=dotnet-35129-website#preparing-environment

# Install 

`./dotnet-install.sh --channel 9.0.1xx --quality preview`

echo 'export DOTNET_ROOT=$HOME/.dotnet' >> ~/.bashrc
echo 'export PATH=$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools' >> ~/.bashrc