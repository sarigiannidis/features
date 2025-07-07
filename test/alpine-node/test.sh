#!/bin/sh

set -e

. dev-container-features-test-lib

check "node --version" | grep -E 'v[0-9]+\.[0-9]+\.[0-9]+'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults