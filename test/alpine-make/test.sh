#!/bin/bash

set -e

source dev-container-features-test-lib

# Test make installation and version
check "make is installed" which make
check "make version" make --version
check "make version format" make --version | grep -E 'GNU Make [0-9]+\.[0-9]+'

# Test basic make functionality
check "create test makefile" cat > /tmp/test-makefile << 'EOF'
.PHONY: test clean
TARGET = hello

test:
	@echo "Testing make functionality"
	@echo "Make is working correctly"

$(TARGET):
	@echo "Building $(TARGET)"
	@touch $(TARGET)

clean:
	@echo "Cleaning up"
	@rm -f $(TARGET)
EOF

# Test make commands
check "make test target" cd /tmp && make -f test-makefile test
check "make build target" cd /tmp && make -f test-makefile hello
check "make clean target" cd /tmp && make -f test-makefile clean

# Test that build tools are available (if build-base is installed)
if command -v gcc >/dev/null 2>&1; then
    check "gcc is available" gcc --version
    check "compile simple C program" cd /tmp && echo 'int main(){return 0;}' > test.c && gcc test.c -o test && ./test
fi

# Test parallel make
check "make supports parallel builds" cd /tmp && make -f test-makefile -j2 test

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
