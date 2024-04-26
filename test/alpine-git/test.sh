#!/bin/bash

set -e

source dev-container-features-test-lib

check "git --version" | grep 'git version 2.43.0'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults