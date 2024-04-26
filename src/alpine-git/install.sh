#!/bin/sh
set -e

echo "Activating feature 'alpine-jekyll'"

echo "Updating repository indexes"
apk update

echo "Adding required packages"
apk add git github-cli