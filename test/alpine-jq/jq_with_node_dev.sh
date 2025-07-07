#!/bin/sh

set -e

echo "Testing jq with node development scenario..."

# Test bash, node, and jq are all available
echo "Checking bash installation..."
if [ -n "$BASH_VERSION" ]; then
    echo "✓ bash is available: $BASH_VERSION"
else
    echo "✗ bash is not available"
    exit 1
fi

echo "Checking node installation..."
if command -v node >/dev/null 2>&1; then
    echo "✓ node is installed"
    node --version
else
    echo "✗ node is not installed"
    exit 1
fi

echo "Checking npm installation..."
if command -v npm >/dev/null 2>&1; then
    echo "✓ npm is installed"
    npm --version
else
    echo "✗ npm is not installed"
    exit 1
fi

echo "Checking jq installation..."
if command -v jq >/dev/null 2>&1; then
    echo "✓ jq is installed"
    jq --version
else
    echo "✗ jq is not installed"
    exit 1
fi

# Test Node.js + jq workflow
echo "Testing Node.js development workflow with jq..."

# Create a test Node.js project
cd /tmp
mkdir -p node-project
cd node-project

# Create package.json
cat > package.json << 'EOF'
{
  "name": "test-node-app",
  "version": "1.0.0",
  "description": "Test Node.js application",
  "main": "index.js",
  "scripts": {
    "start": "node index.js",
    "dev": "nodemon index.js",
    "test": "jest"
  },
  "dependencies": {
    "express": "^4.18.0"
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "nodemon": "^2.0.0"
  }
}
EOF

# Test common Node.js + jq operations
echo "Testing package.json manipulation with jq..."

# Extract dependencies
DEPS=$(jq -r '.dependencies | keys[]' package.json)
if echo "$DEPS" | grep -q "express"; then
    echo "✓ jq can extract Node.js dependencies"
else
    echo "✗ jq dependency extraction failed"
    exit 1
fi

# Test modifying package.json with jq (common in CI/CD)
jq '.version = "1.0.1"' package.json > package.json.tmp && mv package.json.tmp package.json
NEW_VERSION=$(jq -r '.version' package.json)
if [ "$NEW_VERSION" = "1.0.1" ]; then
    echo "✓ jq can modify Node.js package.json"
else
    echo "✗ jq package.json modification failed"
    exit 1
fi

# Test extracting script commands (useful for automation)
START_CMD=$(jq -r '.scripts.start' package.json)
if [ "$START_CMD" = "node index.js" ]; then
    echo "✓ jq can extract Node.js scripts"
else
    echo "✗ jq script extraction failed"
    exit 1
fi

echo "All jq with Node.js development tests passed!"
