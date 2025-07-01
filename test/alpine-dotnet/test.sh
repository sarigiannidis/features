#!/bin/bash

set -e

source dev-container-features-test-lib

check "dotnet --version" | grep -E '[0-9]+\.[0-9]+\.[0-9]+'

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults