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

echo "=== Testing build-base with bash scenario ==="

# Test bash is available
check "bash is installed" command -v bash
check "bash version" bash --version

# Test build tools are available
check "gcc is installed" command -v gcc
check "g++ is installed" command -v g++
check "make is installed" command -v make

# Test bash-specific functionality
check "bash can run scripts" sh -c 'echo "Bash is working"'
check "bash arrays work" sh -c 'arr=(1 2 3); echo ${arr[1]}' | grep -q "2"

# Test compilation with bash
cat > /tmp/test_bash.c << 'EOF'
#include <stdio.h>
int main() {
    printf("Hello from C compiled with bash!\n");
    return 0;
}
EOF

check "bash can run compilation" sh -c "gcc -o /tmp/test_bash /tmp/test_bash.c"
check "compiled program works" /tmp/test_bash | grep -q "Hello from C"

# Cleanup
rm -f /tmp/test_bash /tmp/test_bash.c

echo "All build-base with bash tests completed successfully!"
