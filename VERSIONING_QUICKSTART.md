# Quick Start: Versioning System

This repository now has a comprehensive automated versioning system! Here's how to use it:

## 📋 For Contributors

### Automatic Versioning (Recommended)

When creating pull requests, add appropriate labels:
- `breaking-change` → Major version bump (e.g., 1.0.0 → 2.0.0)
- `enhancement` → Minor version bump (e.g., 1.0.0 → 1.1.0)
- `bug` → Patch version bump (e.g., 1.0.0 → 1.0.1)

Or use conventional commit messages:
- `feat!: remove deprecated option` → Major bump
- `feat: add new installation option` → Minor bump
- `fix: resolve installation error` → Patch bump

### Manual Versioning

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

## 🎯 For Maintainers

### Version Management Commands

```bash
make version-list           # List all feature versions
make version-check          # Validate version consistency
make version-fix            # Auto-fix version issues
make version-patch          # Bump patch for all features
make version-minor          # Bump minor for all features
make version-major          # Bump major for all features
make changelog              # Generate changelog
```

### Release Process

1. **Merge PR** → Automatic version analysis
2. **Version Updates** → Automated based on labels/commits
3. **Git Tags Created** → Repository and feature-specific tags
4. **Features Published** → To GitHub Container Registry

## 📚 Documentation

- **[VERSIONING.md](VERSIONING.md)** - Complete versioning policy
- **[README.md](README.md#version-management)** - Quick reference
- **[DEVELOPMENT.md](DEVELOPMENT.md)** - Development guidelines

## 🔧 Behind the Scenes

- **GitHub Actions** automatically handle versioning
- **Scripts** provide manual control when needed
- **Validation** ensures consistency across all features
- **Changelog** generation from git history

## 🚀 Example Usage

### In DevContainer Configuration

```json
{
  "features": {
    // Pin to major version (recommended)
    "ghcr.io/sarigiannidis/features/alpine-node:1": {},
    
    // Pin to minor version (more stable)
    "ghcr.io/sarigiannidis/features/alpine-git:1.2": {},
    
    // Pin to exact version (maximum stability)
    "ghcr.io/sarigiannidis/features/alpine-bash:1.0.3": {}
  }
}
```

### Creating a New Feature

```bash
# Create feature with versioning
make create-feature NAME=alpine-rust DESC="Install Rust"

# Feature starts at version 1.0.0
make version-list

# Test and validate
make test-feature FEATURE=alpine-rust
make version-check
```

The versioning system is now ready for production use! 🎉