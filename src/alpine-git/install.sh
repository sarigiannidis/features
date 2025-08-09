#!/bin/sh
# ============================================================================
# Alpine Git Feature Installation Script
# ============================================================================
# Installs Git version control system and GitHub CLI on Alpine Linux.
#
# What this script does:
# 1. Updates Alpine package repository indexes
# 2. Installs Git version control system
# 3. Installs GitHub CLI for GitHub integration
# ============================================================================

set -e

echo "Activating feature 'alpine-git'"

# Update package repository indexes to ensure we get the latest packages
echo "Updating repository indexes"
apk update

# Install Git and GitHub CLI packages
# - git: Version control system
# - github-cli: Official GitHub command line tool
echo "Adding Git and GitHub CLI packages"
apk add git github-cli

echo "Feature 'alpine-git' installed successfully"