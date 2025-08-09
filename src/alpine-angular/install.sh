#!/bin/sh
# ============================================================================
# Alpine Angular Feature Installation Script
# ============================================================================
# Installs Angular CLI for building modern web applications on Alpine Linux.
# This feature depends on Node.js being available (alpine-node).
#
# Requirements:
# - Node.js and npm (provided by alpine-node dependency)
#
# What this script does:
# 1. Installs Angular CLI globally via npm
# ============================================================================

set -e

echo "Activating feature 'alpine-angular'"

# Install Angular CLI globally using npm
# The @angular/cli package provides the 'ng' command for Angular development
echo "Installing Angular CLI globally..."
npm install -g @angular/cli

echo "Angular CLI installation completed successfully"