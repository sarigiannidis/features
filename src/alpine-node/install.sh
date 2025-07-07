#!/bin/sh
set -e

echo "Activating feature 'alpine-node'"

echo "Updating repository indexes"
apk update

echo "Adding required packages"
apk add nodejs npm