#!/bin/sh
set -e

echo "Activating feature 'alpine-make'"

echo "Installing GNU Make..."

echo "Updating repository indexes"
apk update

echo "Adding GNU Make"
apk add make

# Verify installation
echo "Verifying make installation..."
make --version

echo "Feature 'alpine-make' installed successfully"
