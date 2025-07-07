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

echo "=== Testing make with bash scenario ==="

# Test bash is available
check "bash is installed" command -v bash

# Test make installation
check "make is installed" command -v make

# Test make with bash functionality
mkdir -p /tmp/make-bash-test
cd /tmp/make-bash-test

# Create a Makefile that uses bash features
cat > Makefile << 'EOF'
SHELL := /bin/bash
.PHONY: all test-bash test-arrays test-conditions

all: test-bash test-arrays test-conditions

test-bash:
	@echo "Testing bash in make..."
	@bash -c 'echo "Bash works in make!"'

test-arrays:
	@echo "Testing bash arrays..."
	@bash -c 'arr=(one two three); echo "Array element 2: $${arr[1]}"'

test-conditions:
	@echo "Testing bash conditions..."
	@bash -c 'if [[ "test" == "test" ]]; then echo "Bash conditions work!"; fi'

test-functions:
	@echo "Testing bash functions..."
	@bash -c 'function greet() { echo "Hello $$1!"; }; greet "Make"'
EOF

# Test make with bash features
check "make with bash works" make test-bash | grep -q "Bash works in make"
check "make with bash arrays works" make test-arrays | grep -q "Array element 2: two"
check "make with bash conditions works" make test-conditions | grep -q "Bash conditions work"
check "make with bash functions works" make test-functions | grep -q "Hello Make"

# Test make with bash scripts
cat > build.sh << 'EOF'
#!/bin/bash
echo "Running bash build script..."
echo "Arguments received: $@"
EOF
chmod +x build.sh

cat > Makefile << 'EOF'
.PHONY: run-script

run-script:
	@./build.sh arg1 arg2
EOF

check "make can run bash scripts" make run-script | grep -q "Running bash build script"

# Cleanup
cd /tmp
rm -rf /tmp/make-bash-test

echo "All make with bash tests completed successfully!"
