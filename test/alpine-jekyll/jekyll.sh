#!/bin/bash

set -e

# Simple test functions
check() {
    local desc="$1"
    shift
    echo "Testing: $desc"
    if "$@"; then
        echo "✓ $desc"
        return 0
    else
        echo "✗ $desc"
        return 1
    fi
}

echo "=== Testing jekyll scenario ==="

# Test Jekyll installation
check "jekyll is installed" command -v jekyll
check "jekyll version" jekyll --version

# Test bundler installation (usually comes with Jekyll)
check "bundler is installed" command -v bundler || command -v bundle
check "gem is installed" command -v gem

# Test Jekyll functionality
mkdir -p /tmp/jekyll-test
cd /tmp/jekyll-test

# Create a minimal Jekyll site
check "jekyll new site works" jekyll new . --force --skip-bundle

# Check that essential files were created
check "Gemfile exists" test -f Gemfile
check "_config.yml exists" test -f _config.yml
check "index.markdown exists" test -f index.markdown || test -f index.md

# Test Jekyll build (without installing gems to keep test fast)
# Create a minimal _config.yml if it doesn't exist properly
cat > _config.yml << 'EOF'
title: Test Site
description: A test Jekyll site
baseurl: ""
url: ""
markdown: kramdown
highlighter: rouge
theme: minima
plugins:
  - jekyll-feed
EOF

# Test that Jekyll can at least parse the site structure
check "jekyll doctor works" jekyll doctor

# Test basic Jekyll commands
check "jekyll help works" jekyll help

# Cleanup
cd /tmp
rm -rf /tmp/jekyll-test

echo "All jekyll tests completed successfully!"
