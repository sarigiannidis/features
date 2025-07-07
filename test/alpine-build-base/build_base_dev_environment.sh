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

echo "=== Testing build-base dev environment scenario ==="

# Test bash is available
check "bash is installed" command -v bash

# Test git is available
check "git is installed" command -v git
check "git version" git --version

# Test build tools are available
check "gcc is installed" command -v gcc
check "g++ is installed" command -v g++
check "make is installed" command -v make

# Test a complete development workflow
mkdir -p /tmp/dev-test
cd /tmp/dev-test

# Initialize a git repo
check "git init works" git init
check "git config works" bash -c "git config user.name 'Test' && git config user.email 'test@example.com'"

# Create a simple C project
cat > hello.c << 'EOF'
#include <stdio.h>
int main() {
    printf("Hello Development Environment!\n");
    return 0;
}
EOF

cat > Makefile << 'EOF'
hello: hello.c
	gcc -o hello hello.c

clean:
	rm -f hello

.PHONY: clean
EOF

# Test the development workflow
check "make builds project" make hello
check "compiled program works" ./hello | grep -q "Hello Development"
check "git can add files" git add .
check "git can commit" git commit -m "Initial commit"
check "git log works" git log --oneline | grep -q "Initial commit"

# Cleanup
cd /tmp
rm -rf /tmp/dev-test

echo "All build-base dev environment tests completed successfully!"
