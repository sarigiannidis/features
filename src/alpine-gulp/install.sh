#!/bin/sh
# ============================================================================
# Alpine Gulp Feature Installation Script
# ============================================================================
# Installs Gulp toolkit for automating development workflows on Alpine Linux.
# This feature depends on Node.js being available (alpine-node).
#
# Requirements:
# - Node.js and npm (provided by alpine-node dependency)
#
# What this script does:
# 1. Installs Gulp CLI globally via npm
# ============================================================================

set -e

echo "Activating feature 'alpine-gulp'"

# Install Gulp CLI globally using npm
# The gulp-cli package provides the 'gulp' command for task automation
echo "Installing Gulp CLI globally..."
npm install -g gulp-cli

echo "Gulp CLI installation completed successfully"
