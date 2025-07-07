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

echo "=== Testing node with dependencies scenario ==="

# Test all required tools are available
check "bash is installed" command -v bash
check "git is installed" command -v git
check "node is installed" command -v node
check "npm is installed" command -v npm

# Check Node.js version
check "node version is v20.x" node --version | grep -E "^v20\."

# Test Node.js with git integration
mkdir -p /tmp/node-deps-test
cd /tmp/node-deps-test

# Initialize git repo
check "git init works" git init
check "git config works" sh -c "git config user.name 'Test' && git config user.email 'test@example.com'"

# Create a Node.js project with git integration
cat > package.json << 'EOF'
{
  "name": "node-with-deps-test",
  "version": "1.0.0",
  "description": "Test Node.js with dependencies",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "test": "node test.js",
    "git-info": "node git-info.js"
  },
  "repository": {
    "type": "git",
    "url": "."
  }
}
EOF

# Create main application
cat > index.js << 'EOF'
const { execSync } = require('child_process');

console.log('Node.js with Git Integration Test');
console.log('Node version:', process.version);

try {
  const gitBranch = execSync('git branch --show-current', { encoding: 'utf8' }).trim();
  console.log('Current git branch:', gitBranch || 'main');
} catch (e) {
  console.log('Git branch: not available');
}

console.log('Application started successfully!');
EOF

# Create git info script
cat > git-info.js << 'EOF'
const { execSync } = require('child_process');

try {
  const gitStatus = execSync('git status --porcelain', { encoding: 'utf8' });
  if (gitStatus.trim()) {
    console.log('Git status: Changes detected');
  } else {
    console.log('Git status: Clean working directory');
  }
  
  const gitCommit = execSync('git rev-parse --short HEAD', { encoding: 'utf8' }).trim();
  console.log('Current commit:', gitCommit);
} catch (e) {
  console.log('Git info not available:', e.message);
}
EOF

# Create test script
cat > test.js << 'EOF'
console.log('Running tests...');

// Test Node.js features
const assert = require('assert');

// Test basic functionality
assert.strictEqual(1 + 1, 2, 'Math works');
console.log('✓ Basic math test passed');

// Test async functionality
async function testAsync() {
  return new Promise(resolve => {
    setTimeout(() => resolve('Async test passed'), 10);
  });
}

testAsync().then(result => {
  console.log('✓', result);
  console.log('All tests completed successfully!');
});
EOF

# Commit initial setup
check "git add works" git add .
check "git commit works" git commit -m "Initial Node.js project setup"

# Test Node.js application
check "node app starts" npm start | grep -q "Application started successfully"
check "node tests run" npm test | grep -q "All tests completed successfully"
check "node git integration works" npm run git-info | grep -q "Current commit:"

# Test that Node.js can interact with git
echo "// Updated file" >> index.js
check "node can detect git changes" npm run git-info | grep -q "Changes detected"

# Cleanup
cd /tmp
rm -rf /tmp/node-deps-test

echo "All node with dependencies tests completed successfully!"
