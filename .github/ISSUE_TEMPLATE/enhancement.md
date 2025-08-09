---
name: ⚡ Enhancement
about: Suggest an improvement to an existing DevContainer feature
title: '[ENHANCEMENT] '
labels: 'enhancement'
assignees: ''

---

## Feature to Enhance
Which existing DevContainer feature would you like to improve?
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

## Enhancement Description
A clear and concise description of the improvement you'd like to see.

## Problem or Limitation
What current limitation or problem would this enhancement address?
- Is there missing functionality?
- Could the installation be improved?
- Are there configuration options that should be added?
- Performance or compatibility issues?

## Proposed Solution
Describe your proposed improvement:
- What changes would you like to see?
- How should it work from a user perspective?
- What new configuration options might be needed?

## Example Configuration
If this enhancement involves new configuration options, show how they would be used:
```json
{
  "features": {
    "ghcr.io/sarigiannidis/features/alpine-[feature]:latest": {
      // current options
      "existingOption": "value",
      // proposed new options
      "newOption": "proposed-value"
    }
  }
}
```

## Alternatives Considered
Describe any alternative solutions or workarounds you've considered:
- Different approaches to achieve the same goal
- Existing tools or methods that partially solve the problem
- Why those alternatives are insufficient

## Impact Assessment
How would this enhancement affect the feature?
- [ ] Backward compatible (existing configurations continue to work)
- [ ] Requires migration (breaking change)
- [ ] New optional functionality
- [ ] Performance improvement
- [ ] Security improvement
- [ ] Bug fix

## Implementation Notes
If you have ideas about implementation:
- Specific Alpine packages that might be needed
- Installation steps or commands
- Configuration file changes
- Testing considerations

## Additional Context
- Links to relevant documentation
- Examples from other similar tools
- Screenshots or examples of expected behavior