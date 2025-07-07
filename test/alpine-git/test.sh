#!/bin/bash

set -e

# Simple test functions
check() {
    local desc="$1"
    shift
    echo "Testing: $desc"
    if "$@"; then
        echo "✓ $desc"
        return 0
    else
        echo "✗ $desc"
        return 1
    fi
}

# Test git installation and version
check "git version" git --version
check "git version format" bash -c 'git --version | grep -E "git version [0-9]+\.[0-9]+\.[0-9]+"'

# Test GitHub CLI installation
check "gh version" gh --version
check "gh version format" bash -c 'gh --version | grep -E "gh version [0-9]+\.[0-9]+\.[0-9]+"'

# Test basic git functionality
check "git config" bash -c 'git config --global user.name "Test User" && git config --global user.email "test@example.com"'
check "git init" bash -c 'cd /tmp && mkdir test-repo && cd test-repo && git init'
check "git add and commit" bash -c 'cd /tmp/test-repo && echo "test" > test.txt && git add test.txt && git commit -m "Initial commit"'

# Test that git commands work
check "git status" bash -c 'cd /tmp/test-repo && git status'
check "git log" bash -c 'cd /tmp/test-repo && git log --oneline'

echo "All tests completed successfully!"