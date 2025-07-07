#!/bin/sh

set -e

. dev-container-features-test-lib

check "python --version" | grep 'Python 3'
check "python3 --version" | grep 'Python 3'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults