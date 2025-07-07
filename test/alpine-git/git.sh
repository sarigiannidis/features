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

echo "=== Testing git scenario ==="

# Test git installation and version
check "git is installed" command -v git
check "git version" git --version

# Test GitHub CLI installation
check "gh is installed" command -v gh
check "gh version" gh --version

# Test basic git functionality
check "git config works" bash -c "git config --global user.name 'Test User' && git config --global user.email 'test@example.com'"

# Create a test repository
mkdir -p /tmp/git-test
cd /tmp/git-test

check "git init works" git init
check "git status works" git status

# Test file operations
echo "Hello Git!" > README.md
check "git add works" git add README.md
check "git commit works" git commit -m "Initial commit"
check "git log works" git log --oneline | grep -q "Initial commit"

# Test branching
check "git branch works" git branch feature-test
check "git checkout works" git checkout feature-test
echo "Feature content" > feature.txt
check "git add on branch works" git add feature.txt
check "git commit on branch works" git commit -m "Add feature"

# Test merging
check "git checkout main works" git checkout master || git checkout main
check "git merge works" git merge feature-test

# Test remote simulation (without actual remote)
check "git remote add works" git remote add origin https://github.com/test/repo.git
check "git remote list works" git remote -v | grep -q "origin"

# Cleanup
cd /tmp
rm -rf /tmp/git-test

echo "All git tests completed successfully!"
