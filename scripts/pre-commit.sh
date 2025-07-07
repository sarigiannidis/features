#!/bin/bash

# Pre-commit hook to validate features before commit
# Install: ln -s ../../scripts/pre-commit.sh .git/hooks/pre-commit

set -e

echo "Running pre-commit validation..."

# Function to validate feature JSON files
validate_json() {
    local file=$1
    if ! jq . "$file" >/dev/null 2>&1; then
        echo "❌ Invalid JSON syntax in $file"
        return 1
    fi
    echo "✓ Valid JSON: $file"
    return 0
}

# Function to validate shell scripts
validate_shell() {
    local file=$1
    if command -v shellcheck >/dev/null 2>&1; then
        if ! shellcheck "$file"; then
            echo "❌ Shell script validation failed for $file"
            return 1
        fi
        echo "✓ Shell script validation passed: $file"
    else
        echo "⚠️  shellcheck not found, skipping shell script validation"
    fi
    return 0
}

# Get list of staged files
staged_files=$(git diff --cached --name-only)

validation_failed=false

# Validate JSON files
for file in $staged_files; do
    if [[ $file == *"devcontainer-feature.json" ]]; then
        if ! validate_json "$file"; then
            validation_failed=true
        fi
    fi
done

# Validate shell scripts
for file in $staged_files; do
    if [[ $file == *".sh" ]]; then
        if ! validate_shell "$file"; then
            validation_failed=true
        fi
    fi
done

# Check if all features have required files
for feature_dir in src/*/; do
    if [ -d "$feature_dir" ]; then
        feature_name=$(basename "$feature_dir")
        
        # Check for required files
        if [ ! -f "$feature_dir/devcontainer-feature.json" ]; then
            echo "❌ Missing devcontainer-feature.json in $feature_name"
            validation_failed=true
        fi
        
        if [ ! -f "$feature_dir/install.sh" ]; then
            echo "❌ Missing install.sh in $feature_name"
            validation_failed=true
        fi
        
        # Check if install.sh is executable
        if [ -f "$feature_dir/install.sh" ] && [ ! -x "$feature_dir/install.sh" ]; then
            echo "⚠️  Making install.sh executable for $feature_name"
            chmod +x "$feature_dir/install.sh"
            git add "$feature_dir/install.sh"
        fi
    fi
done

if [ "$validation_failed" = true ]; then
    echo ""
    echo "❌ Pre-commit validation failed. Please fix the issues above before committing."
    exit 1
fi

echo ""
echo "✅ All pre-commit validations passed!"
exit 0
