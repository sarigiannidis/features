#!/bin/sh
set -e

echo "Activating feature 'alpine-chromium'"

echo "Updating repository indexes"
apk update

echo "Adding required packages"
apk add chromium