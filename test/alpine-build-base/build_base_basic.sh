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

echo "=== Testing build-base basic scenario ==="

# Test essential build tools are installed
check "gcc is installed" command -v gcc
check "g++ is installed" command -v g++
check "make is installed" command -v make
check "libc-dev is available" ls /usr/include/stdio.h

# Test gcc functionality
echo 'int main() { return 0; }' > /tmp/test.c
check "gcc can compile C" gcc -o /tmp/test /tmp/test.c
check "compiled C program runs" /tmp/test

# Test g++ functionality  
echo 'int main() { return 0; }' > /tmp/test.cpp
check "g++ can compile C++" g++ -o /tmp/test_cpp /tmp/test.cpp
check "compiled C++ program runs" /tmp/test_cpp

# Test make functionality
cat > /tmp/Makefile << 'EOF'
test:
	@echo "Make is working"
EOF
check "make works" bash -c "cd /tmp && make test"

# Cleanup
rm -f /tmp/test /tmp/test.c /tmp/test_cpp /tmp/test.cpp /tmp/Makefile

echo "All build-base basic tests completed successfully!"
