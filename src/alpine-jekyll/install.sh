#!/bin/sh
set -e

echo "Activating feature 'alpine-jekyll'"

echo "Installing bundler and jekyll"
gem install bundler jekyll

echo "Configuring bundler"
bundle config --global silence_root_warning true