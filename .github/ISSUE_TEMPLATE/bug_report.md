---
name: 🐛 Bug Report
about: Report a bug with a DevContainer feature
title: '[BUG] '
labels: 'bug'
assignees: ''

---

## Bug Description
A clear and concise description of what the bug is.

## Affected Feature
Which DevContainer feature is experiencing the issue?
- [ ] alpine-angular
- [ ] alpine-bash
- [ ] alpine-build-base
- [ ] alpine-chromium
- [ ] alpine-docker-outside-of-docker
- [ ] alpine-dotnet
- [ ] alpine-git
- [ ] alpine-gulp
- [ ] alpine-jekyll
- [ ] alpine-jq
- [ ] alpine-make
- [ ] alpine-next
- [ ] alpine-node
- [ ] alpine-pip
- [ ] alpine-puppeteer
- [ ] alpine-python
- [ ] alpine-ruby
- [ ] alpine-workbox
- [ ] Other (specify): 

## To Reproduce
Steps to reproduce the behavior:
1. Add feature to `.devcontainer/devcontainer.json` with configuration: `{your configuration here}`
2. Build DevContainer with: `devcontainer build`
3. Run command: `...`
4. See error: `...`

## Expected Behavior
A clear and concise description of what you expected to happen.

## DevContainer Configuration
Please share your `.devcontainer/devcontainer.json` configuration:
```json
{
  "features": {
    "ghcr.io/sarigiannidis/features/alpine-[feature]:latest": {
      // your configuration here
    }
  }
}
```

## Environment
- **Base Image**: [e.g., alpine:latest, alpine:3.18]
- **DevContainer CLI Version**: [run `devcontainer --version`]
- **Docker Version**: [run `docker --version`]
- **Host OS**: [e.g., Ubuntu 22.04, macOS 13, Windows 11]

## Error Output
If applicable, paste the complete error output or logs:
```
[paste error output here]
```

## Additional Context
Add any other context about the problem here, such as:
- Does this work with other base images?
- Is this a regression from a previous version?
- Any workarounds you've found?
