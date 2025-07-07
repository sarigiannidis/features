#!/bin/sh
set -e

echo "Activating feature 'alpine-make'"

# Get the includeBuildBase option
INCLUDE_BUILD_BASE=${INCLUDEBUILDBASE:-"true"}

echo "Installing GNU Make..."

echo "Updating repository indexes"
apk update

echo "Adding GNU Make"
apk add make

# Install additional build tools if requested
if [ "$INCLUDE_BUILD_BASE" = "true" ]; then
    echo "Adding build-base package with common build tools..."
    apk add build-base
fi

# Verify installation
echo "Verifying make installation..."
make --version

echo "Feature 'alpine-make' installed successfully"
