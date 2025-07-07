#!/bin/bash

set -e

echo "Testing jq with bash scenario..."

# Test both bash and jq are available
echo "Checking bash installation..."
if [ -n "$BASH_VERSION" ]; then
    echo "✓ bash is available: $BASH_VERSION"
else
    echo "✗ bash is not available"
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

# Test bash + jq integration
echo "Testing bash and jq integration..."

# Create test data
cat > /tmp/data.json << 'EOF'
{
  "users": [
    {"name": "alice", "age": 30},
    {"name": "bob", "age": 25},
    {"name": "charlie", "age": 35}
  ]
}
EOF

# Test bash script with jq
USERS=$(jq -r '.users[].name' /tmp/data.json)
USER_COUNT=$(echo "$USERS" | wc -l)

if [ "$USER_COUNT" -eq 3 ]; then
    echo "✓ bash and jq integration works"
else
    echo "✗ bash and jq integration failed"
    exit 1
fi

# Test bash arrays with jq
readarray -t USER_ARRAY < <(jq -r '.users[].name' /tmp/data.json)
if [ "${#USER_ARRAY[@]}" -eq 3 ] && [ "${USER_ARRAY[0]}" = "alice" ]; then
    echo "✓ bash arrays work with jq"
else
    echo "✗ bash arrays with jq failed"
    exit 1
fi

echo "All jq with bash tests passed!"
