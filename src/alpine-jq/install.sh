#!/bin/sh
# ============================================================================
# Alpine jq Feature Installation Script
# ============================================================================
# Installs jq lightweight command-line JSON processor on Alpine Linux.
#
# What this script does:
# 1. Updates Alpine package repository indexes
# 2. Installs jq JSON processor
# 3. Verifies installation
# ============================================================================

set -e

echo "Activating feature 'alpine-jq'"

# Get the version option (jq in Alpine repos doesn't support version selection)
VERSION=${VERSION:-"latest"}

echo "Installing jq JSON processor..."

# Update package repository indexes to ensure we get the latest packages
echo "Updating repository indexes"
apk update

# Install jq JSON processor package
# jq is a lightweight and flexible command-line JSON processor
echo "Adding jq package"
apk add jq

# Verify installation by checking jq version
echo "Verifying jq installation..."
jq --version

echo "Feature 'alpine-jq' installed successfully"
