#!/bin/sh
set -e

# Install python/pip
echo "Adding python 3"
apk add --update --no-cache python3 

echo "linking python3 to python"
ln -sf python3 /usr/bin/python