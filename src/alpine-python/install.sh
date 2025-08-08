#!/bin/sh
set -e

echo "Activating feature 'alpine-python'"

echo "Installing Python runtime..."
apk add --update --no-cache python3 

echo "Creating python symlink..."
ln -sf python3 /usr/bin/python

# Verify installation
if command -v python3 > /dev/null 2>&1; then
    echo "Python3 installed successfully"
    python3 --version
else
    echo "ERROR: Python3 installation failed"
    exit 1
fi

if command -v python > /dev/null 2>&1; then
    echo "Python symlink created successfully"
    python --version
else
    echo "ERROR: Python symlink creation failed"
    exit 1
fi