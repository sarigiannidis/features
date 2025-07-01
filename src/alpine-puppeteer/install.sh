#!/bin/sh
set -e

echo "Activating feature 'alpine-puppeteer'"

echo "Setting up puppeteer screenshot utility"
chmod +x shot.js

echo "Installing npm dependencies"
npm install

echo "Linking shot utility globally"
npm link

echo "Done!"
