#!/bin/sh
set -e

echo "Activating feature 'alpine-jekyll'"

echo "Updating repository indexes"
apk update

echo "Adding required packages"
apk add build-base libffi-dev ruby-dev

echo "Installing bundler and jekyll"
gem install bundler jekyll

echo "Configuring bundler"
bundle config --global silence_root_warning true