#!/bin/bash

set -e

source dev-container-features-test-lib

check "gulp --version" | grep 'CLI version'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults