# DevContainer Features for Alpine Linux

[![Release](https://github.com/sarigiannidis/features/actions/workflows/release.yaml/badge.svg)](https://github.com/sarigiannidis/features/actions/workflows/release.yaml)
[![Test](https://github.com/sarigiannidis/features/actions/workflows/test.yaml/badge.svg)](https://github.com/sarigiannidis/features/actions/workflows/test.yaml)

A collection of DevContainer features specifically designed for Alpine Linux containers. These features provide easy installation of development tools and runtimes on Alpine Linux.

## Available Features

| Feature                          | Description                                       |
|----------------------------------|---------------------------------------------------|
| alpine-angular                   | Angular CLI on Alpine Linux                      |
| alpine-bash                      | Bash shell on Alpine Linux                       |
| alpine-chromium                  | Chromium browser on Alpine Linux                 |
| alpine-docker-outside-of-docker  | Docker CLI with socket forwarding for Alpine     |
| alpine-dotnet                    | .NET SDK on Alpine Linux                         |
| alpine-git                       | Git and GitHub CLI on Alpine Linux               |
| alpine-gulp                      | Gulp task runner on Alpine Linux                 |
| alpine-jekyll                    | Jekyll static site generator on Alpine Linux     |
| alpine-next                      | Next.js on Alpine Linux                          |
| alpine-node                      | Node.js and npm on Alpine Linux                  |
| alpine-pip                       | Python pip package manager on Alpine Linux       |
| alpine-puppeteer                 | Puppeteer for browser automation on Alpine Linux |
| alpine-python                    | Python runtime on Alpine Linux                   |
| alpine-ruby                      | Ruby runtime on Alpine Linux                     |
| alpine-workbox                   | Workbox for PWA development on Alpine Linux      |

## Quick Start

Add any feature to your `.devcontainer/devcontainer.json`:

```json
{
    "image": "alpine:latest",
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-node:latest": {
            "version": "20"
        },
        "ghcr.io/sarigiannidis/features/alpine-git:latest": {}
    }
}
```

## Development

### Prerequisites

- [Docker](https://docker.com)
- [DevContainer CLI](https://github.com/devcontainers/cli): `npm install -g @devcontainers/cli`
- [jq](https://stedolan.github.io/jq/) for JSON processing
- [make](https://www.gnu.org/software/make/) (optional, for convenience)

### Setup Development Environment

```bash
# Install dependencies
make install-deps

# Setup git hooks
make setup-hooks

# Validate all features
make validate

# Run all tests
make test
```

### Testing

```bash
# Test all features
make test

# Test a specific feature
make test-feature FEATURE=alpine-git

# Test locally with verbose output
./scripts/test-local.sh alpine-node
```

### Creating New Features

```bash
# Create a new feature
make create-feature NAME=alpine-rust DESC="Install Rust on Alpine Linux"

# Or use the script directly
./scripts/create-feature.sh alpine-rust "Install Rust on Alpine Linux"
```

### Available Make Commands

Run `make help` to see all available commands:

```bash
make help                    # Show help
make install-deps           # Install required dependencies
make setup-hooks            # Setup git pre-commit hooks
make test                    # Run all tests
make test-feature FEATURE=  # Test specific feature
make validate               # Validate all features
make lint                   # Lint shell scripts
make create-feature NAME=   # Create new feature
make generate-docs          # Generate documentation
make list-features          # List all features
make clean                  # Clean up

# Version Management
make version-list           # List all features and versions
make version-check          # Check version consistency
make version-fix            # Fix version issues automatically
make version-patch          # Bump patch version for all features
make version-minor          # Bump minor version for all features  
make version-major          # Bump major version for all features
make version-report         # Generate version report
```

### Version Management

This repository follows [Semantic Versioning](https://semver.org/) principles. See [VERSIONING.md](VERSIONING.md) for the complete versioning policy.

#### Automated Versioning

Versions are automatically managed through GitHub Actions based on:

- **Pull Request Labels**: `breaking-change`, `enhancement`, `bug`, etc.
- **Commit Messages**: Using conventional commit format (`feat:`, `fix:`, etc.)

#### Manual Versioning

```bash
# Check current versions
make version-list

# Bump patch version for all features
make version-patch

# Bump minor version for specific feature
make version-minor FEATURE=alpine-node

# Check version consistency
make version-check
```

## Contributing

1. **Fork and clone** the repository
2. **Setup development environment**: `make install-deps && make setup-hooks`
3. **Create a new feature**: `make create-feature NAME=alpine-yourfeature`
4. **Implement the feature** in `src/alpine-yourfeature/install.sh`
5. **Add tests** in `test/alpine-yourfeature/test.sh`
6. **Test locally**: `make test-feature FEATURE=alpine-yourfeature`
7. **Validate**: `make validate`
8. **Submit a pull request**

### Feature Structure

Each feature should have:

```
src/alpine-yourfeature/
├── devcontainer-feature.json  # Feature metadata
├── install.sh                 # Installation script
└── README.md                  # Feature documentation

test/alpine-yourfeature/
├── test.sh                    # Test script
└── scenarios.json             # Test scenarios (optional)
```

### Testing Best Practices

- Test installation success
- Test version commands
- Test basic functionality
- Use multiple scenarios when applicable
- Keep tests fast and reliable

## Generate Documentation

```bash
devcontainer features generate-docs -n sarigiannidis/features -p ./src/
```

## Resources

- <https://containers.dev/implementors/features/>
- <https://containers.dev/implementors/json_reference/#general-properties>
- <https://github.com/devcontainers/cli>
- <https://github.com/devcontainers/feature-starter/>
- <https://github.com/devcontainers/features/>
