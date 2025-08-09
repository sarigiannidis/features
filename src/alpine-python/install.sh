#!/bin/sh
# ============================================================================
# Alpine Python Feature Installation Script
# ============================================================================
# Installs Python programming language and runtime on Alpine Linux.
#
# What this script does:
# 1. Installs Python 3 runtime
# 2. Creates a symlink from 'python' to 'python3' for compatibility
# ============================================================================

set -e

echo "Activating feature 'alpine-python'"

# Install Python 3 runtime
# --update ensures we get the latest version
# --no-cache prevents caching to keep image size small
echo "Installing Python 3 runtime..."
apk add --update --no-cache python3 

# Create a symlink for compatibility
# Many scripts expect 'python' command, but Alpine only provides 'python3'
echo "Creating python -> python3 symlink for compatibility..."
ln -sf python3 /usr/bin/python

echo "Feature 'alpine-python' installed successfully"