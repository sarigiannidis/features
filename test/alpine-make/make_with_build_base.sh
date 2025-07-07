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

echo "=== Testing make with build-base scenario ==="

# Test make installation
check "make is installed" command -v make

# Test build tools are available
check "gcc is installed" command -v gcc
check "g++ is installed" command -v g++

# Test make with compilation
mkdir -p /tmp/make-build-test
cd /tmp/make-build-test

# Create a C project with Makefile
cat > main.c << 'EOF'
#include <stdio.h>
int main() {
    printf("Hello from C compiled with Make!\n");
    return 0;
}
EOF

cat > utils.c << 'EOF'
#include <stdio.h>
#include "utils.h"
void print_utils() {
    printf("Utils module loaded\n");
}
EOF

cat > utils.h << 'EOF'
#ifndef UTILS_H
#define UTILS_H
void print_utils();
#endif
EOF

# Create a sophisticated Makefile
cat > Makefile << 'EOF'
CC = gcc
CFLAGS = -Wall -Wextra -std=c99
TARGET = myapp
SOURCES = main.c utils.c
OBJECTS = $(SOURCES:.c=.o)

.PHONY: all clean debug release

all: $(TARGET)

$(TARGET): $(OBJECTS)
	$(CC) $(OBJECTS) -o $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJECTS) $(TARGET)

debug: CFLAGS += -g -DDEBUG
debug: $(TARGET)

release: CFLAGS += -O2 -DNDEBUG
release: $(TARGET)

test: $(TARGET)
	./$(TARGET)

install: $(TARGET)
	@echo "Installing $(TARGET)..."
	@echo "Installation complete"
EOF

# Test compilation with make
check "make can compile C project" make
check "compiled program works" ./myapp | grep -q "Hello from C"

# Test different build targets
check "make clean works" make clean
check "make debug works" make debug
check "make test works" make test | grep -q "Hello from C"

# Test make release build
check "make release works" sh -c "make clean && make release"

# Test C++ compilation
cat > test.cpp << 'EOF'
#include <iostream>
int main() {
    std::cout << "Hello from C++ compiled with Make!" << std::endl;
    return 0;
}
EOF

cat > Makefile.cpp << 'EOF'
CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++11
TARGET = cppapp
SOURCE = test.cpp

$(TARGET): $(SOURCE)
	$(CXX) $(CXXFLAGS) $(SOURCE) -o $(TARGET)

clean:
	rm -f $(TARGET)
EOF

check "make can compile C++ project" make -f Makefile.cpp
check "compiled C++ program works" ./cppapp | grep -q "Hello from C++"

# Cleanup
cd /tmp
rm -rf /tmp/make-build-test

echo "All make with build-base tests completed successfully!"
