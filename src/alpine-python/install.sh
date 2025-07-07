#!/bin/sh
set -e

echo "Activating feature 'alpine-python'"

echo "Adding required packages"
apk add --update --no-cache python3 

echo "Linking python3 to python"
ln -sf python3 /usr/bin/python