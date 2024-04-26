#!/bin/bash

set -e

source dev-container-features-test-lib

check "jekyll --version" | grep 'jekyll 4.3.3'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults