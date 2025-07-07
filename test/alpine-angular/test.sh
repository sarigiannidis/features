#!/bin/sh

set -e

source dev-container-features-test-lib

check "ng --version" | grep 'Angular CLI'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults