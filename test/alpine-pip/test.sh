#!/bin/bash

set -e

source dev-container-features-test-lib

check "pip --version" | grep 'pip'
check "pip3 --version" | grep 'pip'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults