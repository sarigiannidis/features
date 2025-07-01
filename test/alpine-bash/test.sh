#!/bin/bash

set -e

source dev-container-features-test-lib

check "bash --version" | grep 'bash'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults