#!/bin/sh
# ============================================================================
# Alpine Puppeteer Feature Installation Script
# ============================================================================
# Installs Puppeteer Node.js library for controlling headless Chrome on Alpine Linux.
# This feature depends on Node.js and Chromium being available (alpine-node, alpine-chromium).
#
# Requirements:
# - Node.js and npm (provided by alpine-node dependency)
# - Chromium browser (provided by alpine-chromium dependency)
#
# What this script does:
# 1. Sets up puppeteer screenshot utility script permissions
# 2. Installs npm dependencies for puppeteer
# 3. Links screenshot utility globally
# ============================================================================

set -e

echo "Activating feature 'alpine-puppeteer'"

# Make the screenshot utility script executable
# The shot.js script provides a convenient command-line interface for taking screenshots
echo "Setting up puppeteer screenshot utility permissions..."
chmod +x shot.js

# Install npm dependencies specified in package.json
# This includes puppeteer and related packages
echo "Installing npm dependencies for puppeteer..."
npm install

# Create global link for the screenshot utility
# This allows the 'shot' command to be used from anywhere
echo "Linking screenshot utility globally..."
npm link

echo "Feature 'alpine-puppeteer' installed successfully"
