#!/bin/bash

set -e

echo "Testing jq with dev tools scenario..."

# Test bash, git, and jq are all available
echo "Checking bash installation..."
if [ -n "$BASH_VERSION" ]; then
    echo "✓ bash is available: $BASH_VERSION"
else
    echo "✗ bash is not available"
    exit 1
fi

echo "Checking git installation..."
if command -v git >/dev/null 2>&1; then
    echo "✓ git is installed"
    git --version
else
    echo "✗ git is not installed"
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

# Test dev workflow: git + jq for processing JSON configs
echo "Testing development workflow with git and jq..."

# Create a test repo with JSON config
cd /tmp
mkdir -p test-repo
cd test-repo
git init
git config user.name "Test User"
git config user.email "test@example.com"

# Create package.json-like file
cat > package.json << 'EOF'
{
  "name": "test-project",
  "version": "1.0.0",
  "scripts": {
    "build": "npm run compile",
    "test": "jest",
    "lint": "eslint ."
  },
  "dependencies": {
    "express": "^4.18.0",
    "lodash": "^4.17.21"
  }
}
EOF

git add package.json
git commit -m "Add package.json"

# Test using jq to process the config
PACKAGE_NAME=$(jq -r '.name' package.json)
if [ "$PACKAGE_NAME" = "test-project" ]; then
    echo "✓ jq can process git-managed JSON files"
else
    echo "✗ jq processing of git-managed files failed"
    exit 1
fi

# Test extracting script names (common dev task)
SCRIPTS=$(jq -r '.scripts | keys[]' package.json)
if echo "$SCRIPTS" | grep -q "build"; then
    echo "✓ jq can extract configuration keys"
else
    echo "✗ jq configuration extraction failed"
    exit 1
fi

echo "All jq with dev tools tests passed!"
