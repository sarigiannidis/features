#!/bin/sh
set -e

echo "Activating feature 'alpine-pip'"

echo "Adding required packages"
apk add --update --no-cache py3-pip
