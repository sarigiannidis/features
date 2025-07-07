# jq JSON processor on Alpine

Install jq - a lightweight and flexible command-line JSON processor on Alpine Linux containers.

jq is like `sed` for JSON data - you can use it to slice and filter and map and transform structured data with the same ease that `sed`, `awk`, `grep` and friends let you play with text.

## Example Usage

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-jq:latest": {}
    }
}
```

### With Development Tools

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-bash:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-git:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-jq:latest": {}
    }
}
```

### For Node.js Development

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-node:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-jq:latest": {}
    }
}
```

## What's Included

- `jq` - Command-line JSON processor

## Common Use Cases

### JSON Parsing and Extraction
```bash
# Extract a field from JSON
echo '{"name": "Alice", "age": 30}' | jq '.name'

# Extract multiple fields
echo '{"name": "Alice", "age": 30}' | jq '{name, age}'
```

### Array Processing
```bash
# Process arrays
echo '[{"name": "Alice"}, {"name": "Bob"}]' | jq '.[].name'

# Filter arrays
echo '[{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}]' | jq '.[] | select(.age > 27)'
```

### Package.json Management
```bash
# Get dependencies from package.json
jq '.dependencies' package.json

# Add a new dependency
jq '.dependencies.lodash = "^4.17.21"' package.json > tmp.json && mv tmp.json package.json
```

### Configuration Processing
```bash
# Pretty print JSON
cat config.json | jq '.'

# Compact JSON
cat config.json | jq -c '.'

# Extract configuration values
jq -r '.database.host' config.json
```

### CI/CD and Automation
```bash
# Parse API responses
curl -s https://api.github.com/repos/user/repo | jq '.stargazers_count'

# Process multiple JSON files
for file in *.json; do jq '.version' "$file"; done
```

## Supported Platforms

- linux/amd64
- linux/arm64

---

_Note: This Feature is published to ghcr.io/sarigiannidis/features._
