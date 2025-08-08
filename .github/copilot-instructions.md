# DevContainer Features Repository - Copilot Instructions

## Repository Overview

This repository contains a collection of **18 DevContainer features** specifically designed for **Alpine Linux containers**. These features provide easy installation of development tools and runtimes (Node.js, Python, .NET, Docker, Git, etc.) on Alpine Linux, which is known for its minimal footprint but sometimes lacks standard development tools.

**Repository Stats:**
- **Language:** Shell scripting (install.sh files), JSON (configuration)
- **Size:** ~554 lines of installation scripts across 18 features
- **Target:** Alpine Linux containers via DevContainer specification
- **Package Manager:** Alpine's `apk` package manager
- **Framework:** DevContainer Features specification

## High-Level Architecture

### Project Structure
```
/
├── src/                          # All 18 DevContainer features
│   └── alpine-{name}/           # Each feature follows this pattern
│       ├── devcontainer-feature.json    # Feature metadata (required)
│       ├── install.sh           # Installation script (required, executable)
│       └── README.md            # Feature documentation
├── test/                        # Mirror of src/ with tests
│   └── alpine-{name}/
│       ├── test.sh              # Test script using dev-container-features-test-lib
│       └── scenarios.json       # Test scenarios (optional)
├── scripts/                     # Development automation
│   ├── test-local.sh           # Local testing script
│   ├── create-feature.sh       # Feature template generator
│   ├── bump-version.sh         # Version management
│   ├── check-versions.sh       # Version validation
│   └── pre-commit.sh           # Git hooks
├── .github/workflows/          # CI/CD automation
│   ├── test.yaml              # Feature testing pipeline
│   ├── release.yaml           # Publishing pipeline
│   └── version.yaml           # Version management
├── Makefile                   # Primary development interface
├── DEVELOPMENT.md             # Comprehensive testing best practices
├── VERSIONING.md              # Semantic versioning policy
└── LOCAL_TESTING.md           # Local testing guide
```

### Available Features
18 features total: alpine-angular, alpine-bash, alpine-build-base, alpine-chromium, alpine-docker-outside-of-docker, alpine-dotnet, alpine-git, alpine-gulp, alpine-jekyll, alpine-jq, alpine-make, alpine-next, alpine-node, alpine-pip, alpine-puppeteer, alpine-python, alpine-ruby, alpine-workbox

## Build, Test, and Development Workflow

### Prerequisites (ALWAYS install first)
```bash
# Required dependencies - verify these exist before any development
make install-deps  # Installs @devcontainers/cli via npm, validates jq and docker
```

**Dependencies verified:** Docker, npm, jq, @devcontainers/cli

### Essential Commands (in order of typical usage)

1. **Setup Development Environment:**
```bash
make install-deps     # Install DevContainer CLI and validate dependencies  
make setup-hooks      # Install git pre-commit hooks for validation
```

2. **Validation (ALWAYS run before committing):**
```bash
make validate         # Validates JSON syntax and feature structure (fast)
make lint            # Runs shellcheck on shell scripts (may show warnings)
make version-check   # Validates version consistency across features
```

3. **Testing (can timeout in restricted networks):**
```bash
make test-feature FEATURE=alpine-jq     # Test single feature (~2-5 minutes)
make test           # Test ALL features (can take 30+ minutes)
./scripts/test-local.sh alpine-jq       # Alternative direct testing
```

**⚠️ Network Dependency Warning:** Testing requires internet access for Alpine package downloads. Tests may timeout (120+ seconds) in restricted environments due to `apk update` operations.

4. **Feature Development:**
```bash
make create-feature NAME=alpine-rust DESC="Install Rust on Alpine Linux"
# Creates: src/alpine-rust/ and test/alpine-rust/ with templates
# Edit: src/alpine-rust/install.sh (main logic)
# Edit: test/alpine-rust/test.sh (validation)
make test-feature FEATURE=alpine-rust   # Test your changes
```

5. **Version Management:**
```bash
make version-list    # Show current versions (all currently 1.0.1 except alpine-python: 1.0.3)
make version-patch   # Bump patch version for all features
make version-minor FEATURE=alpine-node  # Bump specific feature
```

### Build Timing Expectations
- `make validate`: < 5 seconds
- `make lint`: ~10-15 seconds (with warnings)
- `make test-feature FEATURE=X`: 2-5 minutes per feature
- `make test`: 30+ minutes (all features)
- `make install-deps`: ~30 seconds

### Common Issues and Workarounds

1. **Test Timeouts:** Alpine package manager timeouts are common. Retry or test individual features.
2. **Shell Linting:** Scripts show shellcheck warnings but pass. This is expected.
3. **Network Requirements:** All testing requires internet access for Alpine repositories.
4. **Docker Required:** DevContainer CLI requires Docker daemon running.

## Development Patterns

### Creating New Features
1. Use `make create-feature` to generate templates (don't create manually)
2. Edit `src/alpine-{name}/install.sh` with Alpine-specific `apk` commands
3. Keep install scripts minimal (most are 6-21 lines, except docker: 242 lines)
4. Always test locally before committing
5. Follow existing naming pattern: `alpine-{toolname}`

### Feature Install Script Pattern
```bash
#!/bin/sh
# Standard pattern used across features:
set -e
echo "Activating feature '${_FEATURE_ID}'"
echo "Installing {tool}..."
apk update
apk add --no-cache {packages}
# Tool-specific setup if needed
```

### Testing Pattern
- Use `dev-container-features-test-lib` in test scripts
- Test installation success, version commands, basic functionality
- Include multiple scenarios in `scenarios.json` when applicable

## CI/CD and Validation

### GitHub Workflows
1. **test.yaml** - Runs on every PR/push, validates all features using matrix strategy
2. **release.yaml** - Publishes features to GitHub Container Registry on main branch
3. **version.yaml** - Automated version management based on PR labels

### Pre-commit Hooks
Automatically run on `git commit`:
- JSON validation for all `devcontainer-feature.json` files
- Shell script linting with shellcheck
- File structure validation
- Executable permissions check

### Version Policy (VERSIONING.md)
- **Semantic Versioning:** MAJOR.MINOR.PATCH
- **Major:** Breaking changes (option renames, behavior changes)
- **Minor:** New features, backwards compatible
- **Patch:** Bug fixes, security updates

## Key Files for Quick Reference

### Configuration Files
- `devcontainer-feature.json`: Feature metadata (name, id, version, description)
- `scenarios.json`: Test scenarios with different configuration options

### Documentation Files
- `README.md`: Main development guide and feature list
- `DEVELOPMENT.md`: Comprehensive testing best practices implementation
- `LOCAL_TESTING.md`: Guide for running GitHub Actions locally with Act
- `VERSIONING.md`: Complete versioning policy and examples

### Important Scripts
- `Makefile`: All development commands (run `make help` for full list)
- `scripts/test-local.sh`: Local testing with colored output
- `scripts/create-feature.sh`: Feature template generator
- `scripts/pre-commit.sh`: Git validation hooks

## Agent Efficiency Tips

1. **Trust these instructions** - avoid extensive searching/exploration since this repository is well-documented
2. **Always validate first** - run `make validate` before any changes
3. **Use make commands** - don't run devcontainer CLI directly, use the Makefile interface
4. **Test incrementally** - test individual features rather than full test suite during development
5. **Follow templates** - use `make create-feature` rather than copying existing features manually
6. **Check network status** - if tests timeout, it's likely network-related, not code issues
7. **Version management** - use make version-* commands rather than editing JSON files manually

## Example Development Session
```bash
# Setup (one time)
make install-deps && make setup-hooks

# Create new feature
make create-feature NAME=alpine-golang DESC="Install Go programming language"

# Edit src/alpine-golang/install.sh (add apk add go)
# Edit test/alpine-golang/test.sh (add go version test)

# Validate and test
make validate
make test-feature FEATURE=alpine-golang

# Before commit
make lint
git add . && git commit -m "Add alpine-golang feature"
# Pre-commit hooks run automatically
```

This repository is mature and well-structured. Focus on following existing patterns rather than reinventing workflows.