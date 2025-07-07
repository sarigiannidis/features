#!/bin/sh

set -e

# Simple test functions
check() {
    desc="$1"
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

echo "=== Testing make basic scenario ==="

# Test make installation
check "make is installed" command -v make
check "make version" make --version

# Test basic make functionality
mkdir -p /tmp/make-test
cd /tmp/make-test

# Create a simple Makefile
cat > Makefile << 'EOF'
.PHONY: all clean test

all: hello

hello:
	@echo "Hello from Make!"

test:
	@echo "Test target works"

clean:
	@echo "Clean target works"
EOF

# Test make targets
check "make default target works" make | grep -q "Hello from Make"
check "make specific target works" make test | grep -q "Test target works"
check "make clean works" make clean | grep -q "Clean target works"

# Test make with variables
cat > Makefile << 'EOF'
NAME = TestApp
VERSION = 1.0

all:
	@echo "Building $(NAME) version $(VERSION)"

show-vars:
	@echo "NAME=$(NAME)"
	@echo "VERSION=$(VERSION)"
EOF

check "make with variables works" make | grep -q "Building TestApp version 1.0"
check "make can show variables" make show-vars | grep -q "NAME=TestApp"

# Cleanup
cd /tmp
rm -rf /tmp/make-test

echo "All make basic tests completed successfully!"
