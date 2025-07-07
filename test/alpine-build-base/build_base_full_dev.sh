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

echo "=== Testing build-base full dev scenario ==="

# Test bash is available
check "bash is installed" command -v bash

# Test git is available
check "git is installed" command -v git

# Test jq is available
check "jq is installed" command -v jq

# Test build tools are available
check "gcc is installed" command -v gcc
check "g++ is installed" command -v g++
check "make is installed" command -v make

# Test a complete development workflow with all tools
mkdir -p /tmp/full-dev-test
cd /tmp/full-dev-test

# Initialize a git repo
check "git init works" git init
check "git config works" bash -c "git config user.name 'Test' && git config user.email 'test@example.com'"

# Create a project with config file
cat > config.json << 'EOF'
{
    "project": "test-app",
    "version": "1.0.0",
    "build": {
        "compiler": "gcc",
        "flags": ["-Wall", "-O2"]
    }
}
EOF

# Test jq can parse the config
check "jq can read project name" jq -r '.project' config.json | grep -q "test-app"
check "jq can read compiler" jq -r '.build.compiler' config.json | grep -q "gcc"

# Create a C project that uses the config
cat > main.c << 'EOF'
#include <stdio.h>
int main() {
    printf("Full Development Environment Test!\n");
    return 0;
}
EOF

# Create a smart Makefile that uses jq to read config
cat > Makefile << 'EOF'
PROJECT=$(shell jq -r '.project' config.json)
COMPILER=$(shell jq -r '.build.compiler' config.json)
FLAGS=$(shell jq -r '.build.flags | join(" ")' config.json)

$(PROJECT): main.c
	$(COMPILER) $(FLAGS) -o $(PROJECT) main.c

clean:
	rm -f $(PROJECT)

.PHONY: clean
EOF

# Test the full development workflow
check "make with jq config works" make test-app
check "compiled program works" ./test-app | grep -q "Full Development"
check "git can add all files" git add .
check "git can commit" git commit -m "Full dev environment test"

# Test advanced jq usage with git
echo "Testing advanced jq integration..."
git log --format='{"commit":"%H","message":"%s","date":"%ai"}' -1 | \
  check "jq can parse git output" jq -r '.message' | grep -q "Full dev environment"

# Cleanup
cd /tmp
rm -rf /tmp/full-dev-test

echo "All build-base full dev tests completed successfully!"
