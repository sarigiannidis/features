#!/bin/sh
# ============================================================================
# Alpine Ruby Feature Installation Script
# ============================================================================
# Installs Ruby programming language and runtime on Alpine Linux.
# This feature depends on build tools being available (alpine-build-base).
#
# Requirements:
# - Build tools (provided by alpine-build-base dependency)
#
# What this script does:
# 1. Updates Alpine package repository indexes
# 2. Installs Ruby runtime and development packages
# 3. Verifies installation
# ============================================================================

set -e

echo "Activating feature 'alpine-ruby'"

# Update package repository indexes to ensure we get the latest packages
echo "Updating repository indexes"
apk update

# Install Ruby and development packages
# - libffi-dev: Foreign Function Interface library (needed for some gems)
# - ruby-dev: Development files for Ruby (needed to compile native gems)
# - ruby: The Ruby programming language runtime
echo "Installing Ruby and development packages..."
apk add libffi-dev ruby-dev ruby

# Verify installation by checking Ruby version
echo "Verifying Ruby installation..."
ruby --version

echo "Feature 'alpine-ruby' installed successfully"