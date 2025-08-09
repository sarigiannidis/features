#!/bin/sh
# ============================================================================
# Alpine Build Base Feature Installation Script
# ============================================================================
# Installs build-base package with essential build tools on Alpine Linux.
# 
# Build-base includes:
# - gcc (GNU Compiler Collection)
# - g++ (C++ compiler)
# - binutils (Binary utilities)
# - libc-dev (Development files for libc)
# - make (GNU Make)
# - And other essential build tools
#
# What this script does:
# 1. Updates Alpine package repository indexes
# 2. Installs build-base package
# 3. Verifies installation by checking key tools
# ============================================================================

set -e

echo "Activating feature 'alpine-build-base'"

echo "Installing build-base package with essential build tools..."

# Update package repository indexes to ensure we get the latest packages
echo "Updating repository indexes"
apk update

# Install build-base package which provides essential build tools
# This is Alpine's equivalent to build-essential on Debian/Ubuntu
echo "Adding build-base package (includes gcc, g++, binutils, libc-dev, etc.)"
apk add build-base

# Verify installation by checking some key tools are available
echo "Verifying build tools installation..."
gcc --version
make --version

echo "Feature 'alpine-build-base' installed successfully"
