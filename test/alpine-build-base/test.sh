#!/bin/sh

set -e

. dev-container-features-test-lib

# Test that make is available (should come from alpine-make dependency)
check "make is installed" which make
check "make version" make --version

# Test that gcc is available from build-base
check "gcc is installed" which gcc
check "gcc version" gcc --version
check "gcc version format" gcc --version | grep -E 'gcc.*[0-9]+\.[0-9]+\.[0-9]+'

# Test that g++ is available
check "g++ is installed" which g++
check "g++ version" g++ --version

# Test other build-base tools
check "binutils ar is available" which ar
check "binutils ld is available" which ld
check "binutils objdump is available" which objdump
check "file utility is available" which file
check "patch utility is available" which patch

# Test basic C compilation
check "create simple C program" cat > /tmp/hello.c << 'EOF'
#include <stdio.h>
int main() {
    printf("Hello from Alpine build-base!\n");
    return 0;
}
EOF

check "compile C program with gcc" cd /tmp && gcc hello.c -o hello
check "run compiled C program" cd /tmp && ./hello | grep "Hello from Alpine build-base"

# Test C++ compilation
check "create simple C++ program" cat > /tmp/hello.cpp << 'EOF'
#include <iostream>
int main() {
    std::cout << "Hello from C++!" << std::endl;
    return 0;
}
EOF

check "compile C++ program with g++" cd /tmp && g++ hello.cpp -o hello_cpp
check "run compiled C++ program" cd /tmp && ./hello_cpp | grep "Hello from C++"

# Test make functionality with compilation
check "create Makefile" cat > /tmp/Makefile << 'EOF'
CC=gcc
CFLAGS=-Wall -O2
TARGET=test_make
SOURCE=test.c

$(TARGET): $(SOURCE)
	$(CC) $(CFLAGS) $(SOURCE) -o $(TARGET)

clean:
	rm -f $(TARGET)

.PHONY: clean
EOF

check "create test source for Makefile" cat > /tmp/test.c << 'EOF'
#include <stdio.h>
int main() {
    printf("Built with make!\n");
    return 0;
}
EOF

check "build with make" cd /tmp && make test_make
check "run make-built program" cd /tmp && ./test_make | grep "Built with make"
check "clean with make" cd /tmp && make clean

# Test static linking
check "compile statically linked program" cd /tmp && gcc -static hello.c -o hello_static
check "run static program" cd /tmp && ./hello_static | grep "Hello from Alpine build-base"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
