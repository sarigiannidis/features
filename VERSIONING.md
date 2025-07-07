# Versioning Policy

This document defines the versioning policy for DevContainer features in this repository. We follow [Semantic Versioning](https://semver.org/) principles adapted for DevContainer features.

## Version Format

All features use semantic versioning in the format: `MAJOR.MINOR.PATCH`

- **MAJOR** - Incremented for breaking changes
- **MINOR** - Incremented for new features (backwards compatible)
- **PATCH** - Incremented for bug fixes (backwards compatible)

## Version Semantics

### Major Version (X.0.0)

Increment the major version when making **breaking changes** that require users to update their configuration:

- **Removing or renaming feature options**
- **Changing default behavior** that could break existing usage
- **Removing support** for previously supported package versions
- **Changing installation paths** or environment variables
- **Requiring new dependencies** that weren't needed before

**Example breaking changes:**
```json
// v1.x.x - Old option name
{
  "features": {
    "alpine-node:1": { "nodeVersion": "18" }
  }
}

// v2.0.0 - Breaking: option renamed
{
  "features": {
    "alpine-node:2": { "version": "18" }
  }
}
```

### Minor Version (X.Y.0)

Increment the minor version when adding **new functionality** that is backwards compatible:

- **Adding new feature options** with sensible defaults
- **Supporting new package versions** while maintaining old ones
- **Adding new tools** or capabilities to a feature
- **Improving installation performance** or reliability
- **Adding new environment variables** that don't conflict

**Example new features:**
```json
// v1.1.0 - New: added yarn option
{
  "features": {
    "alpine-node:1": { 
      "version": "18",
      "installYarn": true  // New option
    }
  }
}
```

### Patch Version (X.Y.Z)

Increment the patch version for **bug fixes** and minor improvements:

- **Fixing installation errors** or script bugs
- **Updating package repositories** or installation methods
- **Improving error messages** and logging
- **Security patches** for installed packages
- **Documentation fixes** and improvements
- **Performance optimizations** without behavior changes

**Example bug fixes:**
- Fixing package installation failures
- Correcting environment variable settings
- Resolving permission issues

## Versioning Workflow

### Automatic Versioning

Our GitHub Actions workflow automatically determines version increments based on:

1. **Pull Request Labels:**
   - `breaking-change` → Major version bump
   - `enhancement` → Minor version bump
   - `bug`, `documentation`, `dependencies` → Patch version bump

2. **Commit Message Conventions:**
   - `feat!:` or `BREAKING CHANGE:` → Major version bump
   - `feat:` → Minor version bump
   - `fix:`, `docs:`, `chore:` → Patch version bump

### Manual Versioning

For manual version control, use the provided scripts:

```bash
# Bump patch version for all features
./scripts/bump-version.sh patch

# Bump minor version for specific feature
./scripts/bump-version.sh minor alpine-node

# Bump major version for all features
./scripts/bump-version.sh major
```

### Version Tags

Each release creates git tags in the format:

- `v1.2.3` - Repository-wide version tag
- `alpine-node-v1.2.3` - Feature-specific version tag

## Feature Lifecycle

### New Features

New features start at version `1.0.0` when first published.

### Deprecated Features

Features approaching deprecation should:

1. Add deprecation notices in documentation
2. Issue a minor version bump with deprecation warnings
3. After 6 months minimum, issue a major version bump for removal

### Long-Term Support

- **Latest major version** receives all updates
- **Previous major version** receives security patches for 6 months
- **Older versions** are considered end-of-life

## Version Usage Examples

### In DevContainer Configuration

```json
{
  "features": {
    // Pin to major version (recommended)
    "ghcr.io/sarigiannidis/features/alpine-node:1": {},
    
    // Pin to minor version (more stability)
    "ghcr.io/sarigiannidis/features/alpine-git:1.2": {},
    
    // Pin to exact version (maximum stability)
    "ghcr.io/sarigiannidis/features/alpine-bash:1.0.3": {},
    
    // Use latest (not recommended for production)
    "ghcr.io/sarigiannidis/features/alpine-python:latest": {}
  }
}
```

### Version Compatibility

Features may specify compatibility constraints:

```json
{
  "features": {
    "alpine-node:^1.2.0": {},      // >=1.2.0 <2.0.0
    "alpine-python:~1.0.5": {},    // >=1.0.5 <1.1.0
    "alpine-git:1.x": {}           // >=1.0.0 <2.0.0
  }
}
```

## Version Release Process

### Automated Release

1. **Pull Request Merged:** Triggers version analysis
2. **Version Calculation:** Based on labels and commits
3. **Update Feature Files:** Modify `devcontainer-feature.json` files
4. **Create Git Tags:** Repository and feature-specific tags
5. **Publish Features:** To GitHub Container Registry
6. **Generate Changelog:** Automated release notes

### Release Branch Strategy

- `main` branch contains latest stable versions
- Features are published from `main` branch only
- Version bumps create new commits on `main`

## Breaking Change Guidelines

### Planning Breaking Changes

1. **Announce** breaking changes in advance via GitHub issues
2. **Provide migration path** in documentation
3. **Maintain backwards compatibility** during transition period
4. **Update examples** and documentation

### Deprecation Process

1. **Mark as deprecated** in feature documentation
2. **Log deprecation warnings** during installation
3. **Provide timeline** for removal (minimum 6 months)
4. **Create migration guide** for users

## Version Support Matrix

| Version Type | Support Duration | Updates Received |
|--------------|------------------|------------------|
| Latest Major | Indefinite | All features, bug fixes, security |
| Previous Major | 6 months | Bug fixes, security patches |
| Older Versions | None | End of life |

## Examples and Best Practices

### Good Version Increments

```bash
# Fix installation bug → patch
v1.0.0 → v1.0.1

# Add new optional parameter → minor  
v1.0.1 → v1.1.0

# Remove deprecated option → major
v1.1.0 → v2.0.0
```

### Coordination Between Features

When features depend on each other:

1. **Update dependencies first** with compatible versions
2. **Test integration** before releasing dependent features
3. **Use compatible version ranges** in feature dependencies

## Tooling and Automation

### Version Management Scripts

- `scripts/bump-version.sh` - Manual version bumping
- `scripts/check-versions.sh` - Version consistency checking
- `scripts/generate-changelog.sh` - Automated changelog generation

### GitHub Actions Workflows

- `.github/workflows/version.yaml` - Automated versioning
- `.github/workflows/release.yaml` - Feature publishing
- `.github/workflows/test.yaml` - Version validation

### Version Validation

All versions are validated for:
- Semantic versioning format compliance
- Monotonic increment requirements
- Cross-feature dependency compatibility
- Git tag uniqueness

---

This versioning policy ensures consistent, predictable releases while maintaining backwards compatibility and providing clear upgrade paths for users.