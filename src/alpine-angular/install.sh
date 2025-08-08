#!/bin/sh
set -e

echo "Activating feature 'alpine-angular'"

# Verify npm is available
if ! command -v npm > /dev/null 2>&1; then
    echo "ERROR: npm is required but not found. Please install alpine-node feature first."
    exit 1
fi

echo "Installing Angular CLI..."
npm install -g @angular/cli

# Verify installation
if command -v ng > /dev/null 2>&1; then
    echo "Angular CLI installed successfully"
    ng version --version || echo "Angular CLI version info displayed above"
else
    echo "ERROR: Angular CLI installation failed"
    exit 1
fi