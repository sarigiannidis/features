---
name: 🚀 Feature Request
about: Request a new DevContainer feature for Alpine Linux
title: '[FEATURE] alpine-'
labels: 'enhancement, new-feature'
assignees: ''

---

## Feature Description
A clear and concise description of the development tool or runtime you'd like to see as a DevContainer feature.

## Proposed Feature Name
What should this feature be called?
- **Feature ID**: `alpine-[tool-name]`
- **Tool/Runtime**: [e.g., Rust, Go, PHP, PostgreSQL]

## Use Case
Describe the problem this feature would solve or the workflow it would enable:
- What development scenarios would benefit from this feature?
- How would it be used in a DevContainer setup?
- Are there specific Alpine packages or installation steps required?

## Example Configuration
How would users configure this feature in their `.devcontainer/devcontainer.json`?
```json
{
  "features": {
    "ghcr.io/sarigiannidis/features/alpine-[tool-name]:latest": {
      "version": "latest",
      // other potential options
    }
  }
}
```

## Alpine Package Information
- **Primary Alpine Package(s)**: [e.g., `rust`, `go`, `php81`]
- **Additional Dependencies**: [list any additional packages needed]
- **Package Repository**: [main, community, testing, edge]

## Installation Method
How is this tool typically installed on Alpine Linux?
- [ ] Single `apk add` command
- [ ] Multiple packages required
- [ ] Custom installation script needed
- [ ] Requires compilation from source
- [ ] Other (describe):

## Similar Features
Are there existing features in this repository that could serve as a template?
- [ ] Similar to `alpine-node` (runtime with version management)
- [ ] Similar to `alpine-git` (CLI tool)
- [ ] Similar to `alpine-docker-outside-of-docker` (complex setup)
- [ ] Unique requirements

## Additional Context
- Links to official documentation
- Version compatibility requirements
- Special configuration needs
- Any Alpine-specific considerations