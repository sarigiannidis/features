#!/bin/sh
set -e

# Install python/pip
ENV PYTHONUNBUFFERED=1

echo "Adding python 3"
RUN apk add --update --no-cache python3 

echo "linking python3 to python"
ln -sf python3 /usr/bin/python

echo "Adding pip"
RUN python3 -m ensurepip
RUN pip3 install --no-cache --upgrade pip setuptools