#!/bin/sh
# ============================================================================
# Alpine Next.js Feature Installation Script
# ============================================================================
# Installs Next.js React framework for production-ready web applications on Alpine Linux.
# This feature depends on Node.js being available (alpine-node).
#
# Requirements:
# - Node.js and npm (provided by alpine-node dependency)
#
# What this script does:
# 1. Installs Next.js framework globally via npm
# ============================================================================

set -e

echo "Activating feature 'alpine-next'"

# Install Next.js framework globally using npm
# Next.js is a React framework for building full-stack web applications
echo "Installing Next.js framework globally..."
npm install -g next@latest

echo "Next.js installation completed successfully"