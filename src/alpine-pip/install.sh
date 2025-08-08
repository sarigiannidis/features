#!/bin/sh
set -e

echo "Activating feature 'alpine-pip'"

echo "Installing Python pip package manager..."
apk add --update --no-cache py3-pip

# Verify installation
if command -v pip3 > /dev/null 2>&1; then
    echo "pip3 installed successfully"
    pip3 --version
elif command -v pip > /dev/null 2>&1; then
    echo "pip installed successfully"
    pip --version
else
    echo "ERROR: pip installation failed"
    exit 1
fi
