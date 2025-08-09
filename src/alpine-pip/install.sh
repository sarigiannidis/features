#!/bin/sh
# ============================================================================
# Alpine pip Feature Installation Script
# ============================================================================
# Installs pip Python package installer on Alpine Linux.
# This feature depends on Python being available (alpine-python).
#
# Requirements:
# - Python 3 (provided by alpine-python dependency)
#
# What this script does:
# 1. Installs pip Python package manager
# ============================================================================

set -e

echo "Activating feature 'alpine-pip'"

# Install pip Python package installer
# py3-pip is the Alpine package for Python 3 pip
# --update ensures we get the latest version
# --no-cache prevents caching to keep image size small
echo "Installing pip Python package manager..."
apk add --update --no-cache py3-pip

echo "Feature 'alpine-pip' installed successfully"
