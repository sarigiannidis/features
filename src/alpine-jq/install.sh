#!/bin/sh
set -e

echo "Activating feature 'alpine-jq'"

# Get the version option (jq in Alpine repos doesn't support version selection)
VERSION=${VERSION:-"latest"}

echo "Installing jq JSON processor..."

echo "Updating repository indexes"
apk update

echo "Adding jq package"
apk add jq

# Verify installation
echo "Verifying jq installation..."
jq --version

echo "Feature 'alpine-jq' installed successfully"
