#!/bin/sh
# ============================================================================
# Alpine Workbox Feature Installation Script
# ============================================================================
# Installs Workbox libraries for adding progressive web app features on Alpine Linux.
# This feature depends on Node.js being available (alpine-node).
#
# Requirements:
# - Node.js and npm (provided by alpine-node dependency)
#
# What this script does:
# 1. Installs Workbox CLI globally via npm
# ============================================================================

set -e

echo "Activating feature 'alpine-workbox'"

# Install Workbox CLI globally using npm
# Workbox provides tools for adding offline functionality to web apps
echo "Installing Workbox CLI globally..."
npm install -g workbox-cli

echo "Workbox CLI installation completed successfully"