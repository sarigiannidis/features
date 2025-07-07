# Running GitHub Actions Locally

## Using Act

After installing act, you can run specific jobs or workflows:

### Run the entire test workflow

```bash
act -j test
```

### Run just the validate-features job

```bash
act -j validate-features
```

### Run with a specific feature (simulate matrix)

```bash
act -j test --matrix features:alpine-jq
```

### List all available jobs

```bash
act -l
```

### Run with verbose output

```bash
act -j test -v
```

### Use a specific runner image

```bash
act -j test -P ubuntu-latest=catthehacker/ubuntu:act-latest
```

## Alternative: Using the Local Test Script

You can also use the existing local test script:

```bash
# Test a specific feature
./scripts/test-local.sh alpine-jq

# Test all features
./scripts/test-local.sh
```

## DevContainer CLI Direct Testing

Test features directly with the devcontainer CLI:

```bash
# Test a specific feature
devcontainer features test --project-folder . --features alpine-jq --base-image alpine:latest --skip-scenarios

# Test with scenarios
devcontainer features test --project-folder . --features alpine-jq --base-image alpine:latest
```

## Tips

1. **First run**: Act will ask you to choose a runner image. Choose `catthehacker/ubuntu:act-latest` for best compatibility.

2. **Docker required**: Make sure Docker Desktop is running before using act.

3. **Faster iterations**: Use the direct devcontainer CLI commands for fastest feedback.

4. **Matrix testing**: Act can simulate matrix builds with the `--matrix` flag.
