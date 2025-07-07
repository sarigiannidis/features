#!/bin/sh

set -e

. dev-container-features-test-lib

# Test git installation and version
check "git version" git --version
check "git version format" sh -c 'git --version | grep -E "git version [0-9]+\.[0-9]+\.[0-9]+"'

# Test GitHub CLI installation
check "gh version" gh --version
check "gh version format" sh -c 'gh --version | grep -E "gh version [0-9]+\.[0-9]+\.[0-9]+"'

# Test basic git functionality
check "git config" sh -c 'git config --global user.name "Test User" && git config --global user.email "test@example.com"'
check "git init" sh -c 'cd /tmp && mkdir test-repo && cd test-repo && git init'
check "git add and commit" sh -c 'cd /tmp/test-repo && echo "test" > test.txt && git add test.txt && git commit -m "Initial commit"'

# Test that git commands work
check "git status" sh -c 'cd /tmp/test-repo && git status'
check "git log" sh -c 'cd /tmp/test-repo && git log --oneline'

# Report results
reportResults