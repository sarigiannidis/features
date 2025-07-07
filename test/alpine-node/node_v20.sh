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

echo "=== Testing node v20 scenario ==="

# Test Node.js installation
check "node is installed" command -v node
check "npm is installed" command -v npm

# Check that we have Node.js v20.x
check "node version is v20.x" node --version | grep -E "^v20\."

# Test Node.js v20 specific functionality
mkdir -p /tmp/node-v20-test
cd /tmp/node-v20-test

# Create a Node.js app that uses v20 features
cat > app.js << 'EOF'
// Test Node.js v20 features
console.log('Testing Node.js v20');
console.log('Node version:', process.version);

// Test modern JavaScript features available in v20
const testAsync = async () => {
    return 'Async/await works!';
};

const testArrow = () => 'Arrow functions work!';

// Test Promise
Promise.resolve('Promises work!').then(console.log);

// Test async function
testAsync().then(console.log);

console.log(testArrow());

// Test destructuring
const obj = { a: 1, b: 2 };
const { a, b } = obj;
console.log('Destructuring works:', a, b);

// Test template literals
const name = 'Node.js v20';
console.log(`Template literals work with ${name}!`);
EOF

check "node v20 can run modern JavaScript" node app.js | grep -q "Testing Node.js v20"
check "node v20 supports async/await" node app.js | grep -q "Async/await works"
check "node v20 supports promises" node app.js | grep -q "Promises work"

# Test npm with v20
cat > package.json << 'EOF'
{
  "name": "node-v20-test",
  "version": "1.0.0",
  "description": "Test Node.js v20",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "version-check": "node --version"
  },
  "engines": {
    "node": ">=20.0.0"
  }
}
EOF

check "npm works with v20" npm run version-check | grep -E "^v20\."
check "npm start works with v20" npm start | grep -q "Testing Node.js v20"

# Cleanup
cd /tmp
rm -rf /tmp/node-v20-test

echo "All node v20 tests completed successfully!"
