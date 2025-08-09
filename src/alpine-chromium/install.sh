#!/bin/sh
# ============================================================================
# Alpine Chromium Feature Installation Script
# ============================================================================
# Installs Chromium web browser for testing and automation on Alpine Linux.
#
# What this script does:
# 1. Updates Alpine package repository indexes
# 2. Installs Chromium browser package
# 3. Verifies installation
# ============================================================================

set -e

echo "Activating feature 'alpine-chromium'"

# Update package repository indexes to ensure we get the latest packages
echo "Updating repository indexes"
apk update

# Install Chromium browser package
# Chromium is the open-source version of Chrome, commonly used for automation
echo "Adding Chromium browser package"
apk add chromium

echo "Feature 'alpine-chromium' installed successfully"