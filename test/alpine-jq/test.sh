#!/bin/sh

set -e

. dev-container-features-test-lib

# Test jq installation and version
check "jq is installed" which jq
check "jq version" jq --version
check "jq version format" sh -c 'jq --version | grep -E "jq-[0-9]+\.[0-9]+"'

# Test basic jq functionality with JSON parsing
echo "Creating test JSON..."
cat > /tmp/test.json << 'EOF'
{
  "name": "test",
  "version": "1.0.0",
  "dependencies": {
    "lodash": "^4.17.21",
    "express": "^4.18.0"
  },
  "scripts": {
    "start": "node index.js",
    "test": "jest"
  }
}
EOF

# Test basic jq operations
check "jq parse JSON" jq '.' /tmp/test.json
check "jq extract field" sh -c 'jq -r ".name" /tmp/test.json | grep "test"'
check "jq extract version" sh -c 'jq -r ".version" /tmp/test.json | grep "1.0.0"'
check "jq extract nested object" jq '.dependencies' /tmp/test.json
check "jq extract array of keys" sh -c 'jq -r ".dependencies | keys[]" /tmp/test.json | grep -E "(express|lodash)"'

# Test jq with pipes and complex queries
check "jq count dependencies" sh -c 'test "$(jq ".dependencies | length" /tmp/test.json)" -eq 2'
check "jq filter and map" sh -c 'jq -r ".dependencies | to_entries[] | select(.key | startswith(\"e\")) | .key" /tmp/test.json | grep "express"'

# Test jq with arrays
echo "Creating test array JSON..."
echo '[{"id":1,"name":"alice"},{"id":2,"name":"bob"}]' > /tmp/array.json
check "jq map array" sh -c 'jq ".[].name" /tmp/array.json | grep -E "(alice|bob)"'
check "jq filter array" sh -c 'jq ".[] | select(.id == 1) | .name" /tmp/array.json | grep "alice"'

# Test jq with null and empty handling
check "jq handle null values" sh -c 'echo "{\"a\": null, \"b\": \"value\"}" | jq -r ".a // \"default\"" | grep "default"'
check "jq compact output" sh -c 'echo "{\"a\": 1, \"b\": 2}" | jq -c "."'

# Test jq with stdin
check "jq from stdin" sh -c 'echo "{\"hello\": \"world\"}" | jq -r ".hello" | grep "world"'

# Test jq error handling (should exit with non-zero for invalid JSON)
check "jq handles invalid JSON gracefully" sh -c '! echo "invalid json" | jq "." 2>/dev/null'

# Report results
reportResults
