#!/bin/sh

set -e

. dev-container-features-test-lib

check "shot --help" | grep -i 'url'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults