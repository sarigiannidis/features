#!/bin/bash

set -e

source dev-container-features-test-lib

# Test git installation and version
check "git version" git --version
check "git version format" git --version | grep -E 'git version [0-9]+\.[0-9]+\.[0-9]+'

# Test GitHub CLI installation
check "gh version" gh --version
check "gh version format" gh --version | grep -E 'gh version [0-9]+\.[0-9]+\.[0-9]+'

# Test basic git functionality
check "git config" git config --global user.name "Test User" && git config --global user.email "test@example.com"
check "git init" cd /tmp && mkdir test-repo && cd test-repo && git init
check "git add and commit" echo "test" > test.txt && git add test.txt && git commit -m "Initial commit"

# Test that git commands work
check "git status" git status
check "git log" git log --oneline

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults