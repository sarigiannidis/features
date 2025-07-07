#!/bin/sh
set -e

echo "Activating feature 'alpine-ruby'"

echo "Updating repository indexes"
apk update

echo "Adding Ruby and development packages"
apk add libffi-dev ruby-dev ruby

echo "Verifying Ruby installation..."
ruby --version

echo "Feature 'alpine-ruby' installed successfully"