#!/bin/sh
set -e

echo "Activating feature 'alpine-workbox'"

echo "Installing required packages"
npm install -g workbox-cli