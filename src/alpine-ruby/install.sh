#!/bin/sh
set -e

echo "Activating feature 'alpine-ruby'"

echo "Updating repository indexes"
apk update

echo "Adding required packages"
apk add build-base libffi-dev ruby-dev ruby