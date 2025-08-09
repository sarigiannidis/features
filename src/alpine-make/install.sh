#!/bin/sh
# ============================================================================
# Alpine Make Feature Installation Script
# ============================================================================
# Installs GNU Make build automation tool on Alpine Linux.
#
# What this script does:
# 1. Updates Alpine package repository indexes
# 2. Installs GNU Make package
# 3. Verifies installation
# ============================================================================

set -e

echo "Activating feature 'alpine-make'"

echo "Installing GNU Make..."

# Update package repository indexes to ensure we get the latest packages
echo "Updating repository indexes"
apk update

# Install GNU Make build automation tool
# Make is used for building software from source code using Makefiles
echo "Adding GNU Make package"
apk add make

# Verify installation by checking Make version
echo "Verifying make installation..."
make --version

echo "Feature 'alpine-make' installed successfully"
