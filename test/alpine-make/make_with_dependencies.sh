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

echo "=== Testing make with dependencies scenario ==="

# Test all required tools are available
check "bash is installed" command -v bash
check "git is installed" command -v git
check "make is installed" command -v make

# Test make with git integration
mkdir -p /tmp/make-deps-test
cd /tmp/make-deps-test

# Initialize git repo
check "git init works" git init
check "git config works" bash -c "git config user.name 'Test' && git config user.email 'test@example.com'"

# Create a Makefile that uses git
cat > Makefile << 'EOF'
SHELL := /bin/bash
COMMIT_HASH := $(shell git rev-parse --short HEAD 2>/dev/null || echo "unknown")
BRANCH := $(shell git branch --show-current 2>/dev/null || echo "unknown")

.PHONY: all info commit build-info

all: build-info

info:
	@echo "Current commit: $(COMMIT_HASH)"
	@echo "Current branch: $(BRANCH)"

build-info:
	@echo "Building project..."
	@echo "Git commit: $(COMMIT_HASH)"
	@echo "Git branch: $(BRANCH)"

commit:
	@if [[ -n "$$(git status --porcelain)" ]]; then \
		echo "Committing changes..."; \
		git add .; \
		git commit -m "Automated commit from make"; \
	else \
		echo "No changes to commit"; \
	fi

clean:
	@echo "Cleaning up..."
	@rm -f *.tmp
EOF

# Create initial content and commit
echo "Initial content" > README.md
check "git add works" git add .
check "git commit works" git commit -m "Initial commit"

# Test make with git integration
check "make with git info works" make info | grep -q "Current commit:"
check "make build-info works" make build-info | grep -q "Building project"

# Test make can trigger git operations
echo "New content" > new-file.txt
check "make can commit changes" make commit | grep -q "Committing changes"

# Test that make can detect clean state
check "make detects clean state" make commit | grep -q "No changes to commit"

# Cleanup
cd /tmp
rm -rf /tmp/make-deps-test

echo "All make with dependencies tests completed successfully!"
