#!/bin/sh
set -e

echo "Activating feature 'alpine-chromium'"

echo "Updating repository indexes..."
apk update

echo "Installing Chromium browser..."
apk add --no-cache chromium

# Verify installation
if command -v chromium-browser > /dev/null 2>&1; then
    echo "Chromium installed successfully"
    chromium-browser --version
else
    echo "ERROR: Chromium installation failed"
    exit 1
fi