#!/bin/sh
set -e

echo "Activating feature 'alpine-git'"

echo "Updating repository indexes..."
apk update

echo "Installing Git and GitHub CLI..."
apk add --no-cache git github-cli

# Verify installations
if command -v git > /dev/null 2>&1; then
    echo "Git installed successfully"
    git --version
else
    echo "ERROR: Git installation failed"
    exit 1
fi

if command -v gh > /dev/null 2>&1; then
    echo "GitHub CLI installed successfully"
    gh --version
else
    echo "ERROR: GitHub CLI installation failed"
    exit 1
fi