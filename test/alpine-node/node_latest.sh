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

echo "=== Testing node latest scenario ==="

# Test Node.js installation
check "node is installed" command -v node
check "npm is installed" command -v npm
check "node version" node --version
check "npm version" npm --version

# Test basic Node.js functionality
mkdir -p /tmp/node-test
cd /tmp/node-test

# Create a simple Node.js app
cat > app.js << 'EOF'
console.log('Hello from Node.js!');
const version = process.version;
console.log('Node.js version:', version);
EOF

check "node can run JavaScript" node app.js | grep -q "Hello from Node.js"

# Test npm functionality
cat > package.json << 'EOF'
{
  "name": "test-app",
  "version": "1.0.0",
  "description": "Test Node.js app",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "test": "echo \"Test passed\""
  }
}
EOF

check "npm can read package.json" npm list --depth=0
check "npm scripts work" npm run test | grep -q "Test passed"
check "npm start works" npm start | grep -q "Hello from Node.js"

# Test npm package installation (without actually installing to keep test fast)
check "npm init works" sh -c "echo 'test-package' | npm init -y > /dev/null"

# Cleanup
cd /tmp
rm -rf /tmp/node-test

echo "All node latest tests completed successfully!"
