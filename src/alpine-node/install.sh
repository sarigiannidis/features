#!/bin/sh
# ============================================================================
# Alpine Node.js Feature Installation Script
# ============================================================================
# Installs Node.js JavaScript runtime and npm package manager on Alpine Linux.
#
# What this script does:
# 1. Updates Alpine package repository indexes
# 2. Installs Node.js runtime and npm package manager
# ============================================================================

set -e

echo "Activating feature 'alpine-node'"

# Update package repository indexes to ensure we get the latest packages
echo "Updating repository indexes"
apk update

# Install Node.js and npm packages
# - nodejs: JavaScript runtime built on Chrome's V8 JavaScript engine
# - npm: Node Package Manager for installing JavaScript packages
echo "Adding Node.js and npm packages"
apk add nodejs npm

echo "Feature 'alpine-node' installed successfully"