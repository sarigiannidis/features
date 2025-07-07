#!/bin/sh
set -e

echo "Activating feature 'alpine-build-base'"

echo "Installing build-base package with essential build tools..."

echo "Updating repository indexes"
apk update

echo "Adding build-base package (includes gcc, g++, binutils, libc-dev, etc.)"
apk add build-base

# Verify installation by checking some key tools
echo "Verifying build tools installation..."
gcc --version
make --version

echo "Feature 'alpine-build-base' installed successfully"
