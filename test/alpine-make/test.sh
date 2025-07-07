#!/bin/bash

set -e

source dev-container-features-test-lib

# Test make installation and version
check "make is installed" which make
check "make version" make --version
check "make version format" make --version | grep -E 'GNU Make [0-9]+\.[0-9]+'

# Test basic make functionality (without compilation)
check "create simple Makefile" cat > /tmp/test-makefile << 'EOF'
.PHONY: test hello clean
TARGET = hello.txt

test:
	@echo "Testing make functionality"
	@echo "Make is working correctly"

$(TARGET):
	@echo "Creating $(TARGET)"
	@echo "Hello from make!" > $(TARGET)

hello: $(TARGET)
	@cat $(TARGET)

clean:
	@echo "Cleaning up"
	@rm -f $(TARGET)
EOF

# Test make commands (file operations only, no compilation)
check "make test target" cd /tmp && make -f test-makefile test
check "make build target" cd /tmp && make -f test-makefile hello.txt
check "verify created file" cd /tmp && test -f hello.txt && cat hello.txt | grep "Hello from make"
check "make hello target" cd /tmp && make -f test-makefile hello
check "make clean target" cd /tmp && make -f test-makefile clean && test ! -f hello.txt

# Test parallel make
check "make supports parallel builds" cd /tmp && make -f test-makefile -j2 test

# Test make error handling
check "make handles missing targets gracefully" ! cd /tmp && make -f test-makefile nonexistent 2>/dev/null

# Note: We don't test compilation here since alpine-make only provides make
# For compilation tests, see alpine-build-base feature tests

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
