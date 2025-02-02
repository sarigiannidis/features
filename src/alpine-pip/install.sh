#!/bin/sh
set -e

# Install pip
echo "Adding pip"
apk add --update --no-cache py3-pip
