#!/bin/sh
# ============================================================================
# Alpine Jekyll Feature Installation Script
# ============================================================================
# Installs Jekyll static site generator on Alpine Linux.
# This feature depends on Ruby being available (alpine-ruby).
#
# Requirements:
# - Ruby and gems (provided by alpine-ruby dependency)
#
# What this script does:
# 1. Installs Bundler gem (dependency manager for Ruby)
# 2. Installs Jekyll gem (static site generator)
# 3. Configures Bundler to suppress root warnings
# ============================================================================

set -e

echo "Activating feature 'alpine-jekyll'"

# Install Bundler (Ruby dependency manager) and Jekyll (static site generator)
# - bundler: Manages Ruby gem dependencies
# - jekyll: Static site generator for blogs and websites
echo "Installing Bundler and Jekyll gems..."
gem install bundler jekyll

# Configure Bundler to suppress root warning messages
# This prevents annoying warnings when running as root in containers
echo "Configuring Bundler settings..."
bundle config --global silence_root_warning true

echo "Feature 'alpine-jekyll' installed successfully"