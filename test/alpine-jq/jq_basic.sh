#!/bin/sh

set -e

echo "Testing jq basic scenario..."

# Test jq installation and version
echo "Checking jq installation..."
if command -v jq >/dev/null 2>&1; then
    echo "✓ jq is installed"
    jq --version
else
    echo "✗ jq is not installed"
    exit 1
fi

# Test basic jq functionality
echo "Testing basic jq functionality..."

# Create test JSON
cat > /tmp/test.json << 'EOF'
{
  "name": "test",
  "version": "1.0.0",
  "dependencies": {
    "lodash": "^4.17.21",
    "express": "^4.18.0"
  }
}
EOF

# Test basic operations
echo "Testing JSON parsing..."
jq '.' /tmp/test.json > /dev/null
echo "✓ jq can parse JSON"

echo "Testing field extraction..."
NAME=$(jq -r '.name' /tmp/test.json)
if [ "$NAME" = "test" ]; then
    echo "✓ jq can extract fields"
else
    echo "✗ jq field extraction failed"
    exit 1
fi

echo "Testing nested object access..."
jq '.dependencies' /tmp/test.json > /dev/null
echo "✓ jq can access nested objects"

echo "Testing with stdin..."
echo '{"hello": "world"}' | jq -r '.hello' | grep -q "world"
echo "✓ jq works with stdin"

echo "All jq basic tests passed!"
