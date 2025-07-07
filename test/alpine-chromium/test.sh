#!/bin/sh

set -e

. dev-container-features-test-lib

check "chromium-browser --version" | grep 'Chromium'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults