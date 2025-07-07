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

echo "=== Testing node v18 scenario ==="

# Test Node.js installation
check "node is installed" command -v node
check "npm is installed" command -v npm

# Check that we have Node.js v18.x
check "node version is v18.x" node --version | grep -E "^v18\."

# Test Node.js v18 functionality
mkdir -p /tmp/node-v18-test
cd /tmp/node-v18-test

# Create a Node.js app that works with v18
cat > app.js << 'EOF'
// Test Node.js v18 features
console.log('Testing Node.js v18');
console.log('Node version:', process.version);

// Test JavaScript features available in v18
const testAsync = async () => {
    return 'Async/await works in v18!';
};

const testArrow = () => 'Arrow functions work in v18!';

// Test Promise
Promise.resolve('Promises work in v18!').then(console.log);

// Test async function
testAsync().then(console.log);

console.log(testArrow());

// Test ES6+ features
const array = [1, 2, 3, 4, 5];
const doubled = array.map(x => x * 2);
console.log('Array map works:', doubled);

// Test object spread
const obj1 = { a: 1, b: 2 };
const obj2 = { ...obj1, c: 3 };
console.log('Object spread works:', obj2);

// Test template literals
const name = 'Node.js v18';
console.log(`Template literals work with ${name}!`);
EOF

check "node v18 can run JavaScript" node app.js | grep -q "Testing Node.js v18"
check "node v18 supports async/await" node app.js | grep -q "Async/await works in v18"
check "node v18 supports array methods" node app.js | grep -q "Array map works"

# Test npm with v18
cat > package.json << 'EOF'
{
  "name": "node-v18-test",
  "version": "1.0.0",
  "description": "Test Node.js v18",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "version-check": "node --version"
  },
  "engines": {
    "node": ">=18.0.0"
  }
}
EOF

check "npm works with v18" npm run version-check | grep -E "^v18\."
check "npm start works with v18" npm start | grep -q "Testing Node.js v18"

# Cleanup
cd /tmp
rm -rf /tmp/node-v18-test

echo "All node v18 tests completed successfully!"
