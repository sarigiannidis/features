#!/bin/bash

# DevContainer Features Version Management Script
# Provides manual version bumping capabilities

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FEATURES_DIR="$REPO_ROOT/src"

print_status() {
    printf "${1}%s${NC}\n" "$2"
}

show_help() {
    cat << EOF
DevContainer Features Version Management

USAGE:
    $0 <version_type> [feature_name]

VERSION TYPES:
    major       Increment major version (breaking changes)
    minor       Increment minor version (new features)
    patch       Increment patch version (bug fixes)
    
PARAMETERS:
    feature_name    Optional. Specific feature to version.
                   If not provided, all features will be updated.

EXAMPLES:
    # Bump patch version for all features
    $0 patch
    
    # Bump minor version for alpine-node only
    $0 minor alpine-node
    
    # Bump major version for all features
    $0 major

ADDITIONAL COMMANDS:
    $0 list         List all features and their current versions
    $0 check        Check version consistency
    $0 --help       Show this help message

EOF
}

# Function to increment version
increment_version() {
    local version=$1
    local type=$2
    
    # Parse version components
    local major=$(echo $version | cut -d. -f1)
    local minor=$(echo $version | cut -d. -f2)
    local patch=$(echo $version | cut -d. -f3)
    
    # Validate version format
    if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        print_status $RED "Invalid version format: $version"
        return 1
    fi
    
    case $type in
        major)
            major=$((major + 1))
            minor=0
            patch=0
            ;;
        minor)
            minor=$((minor + 1))
            patch=0
            ;;
        patch)
            patch=$((patch + 1))
            ;;
        *)
            print_status $RED "Invalid version type: $type"
            return 1
            ;;
    esac
    
    echo "$major.$minor.$patch"
}

# Function to update feature version
update_feature_version() {
    local feature=$1
    local version_type=$2
    local feature_dir="$FEATURES_DIR/$feature"
    local feature_json="$feature_dir/devcontainer-feature.json"
    
    if [ ! -f "$feature_json" ]; then
        print_status $RED "Feature not found: $feature"
        return 1
    fi
    
    # Check if jq is available
    if ! command -v jq >/dev/null 2>&1; then
        print_status $RED "jq is required but not installed"
        return 1
    fi
    
    # Get current version
    local current_version=$(jq -r '.version // "1.0.0"' "$feature_json")
    
    # Calculate new version
    local new_version=$(increment_version "$current_version" "$version_type")
    
    if [ $? -ne 0 ]; then
        return 1
    fi
    
    print_status $BLUE "Updating $feature: $current_version → $new_version"
    
    # Update the JSON file
    jq --arg version "$new_version" '.version = $version' "$feature_json" > "${feature_json}.tmp"
    mv "${feature_json}.tmp" "$feature_json"
    
    echo "$new_version"
}

# Function to list all features and versions
list_features() {
    print_status $GREEN "Current Feature Versions:"
    print_status $GREEN "========================="
    
    for feature_dir in "$FEATURES_DIR"/*; do
        if [ -d "$feature_dir" ]; then
            local feature_name=$(basename "$feature_dir")
            local feature_json="$feature_dir/devcontainer-feature.json"
            
            if [ -f "$feature_json" ]; then
                local version=$(jq -r '.version // "1.0.0"' "$feature_json" 2>/dev/null || echo "invalid")
                printf "%-30s %s\n" "$feature_name" "$version"
            else
                printf "%-30s %s\n" "$feature_name" "missing JSON"
            fi
        fi
    done
}

# Function to check version consistency
check_versions() {
    print_status $YELLOW "Checking version consistency..."
    
    local issues_found=0
    
    for feature_dir in "$FEATURES_DIR"/*; do
        if [ -d "$feature_dir" ]; then
            local feature_name=$(basename "$feature_dir")
            local feature_json="$feature_dir/devcontainer-feature.json"
            
            if [ ! -f "$feature_json" ]; then
                print_status $RED "❌ Missing JSON file: $feature_name"
                issues_found=$((issues_found + 1))
                continue
            fi
            
            # Check JSON validity
            if ! jq empty "$feature_json" 2>/dev/null; then
                print_status $RED "❌ Invalid JSON syntax: $feature_name"
                issues_found=$((issues_found + 1))
                continue
            fi
            
            # Check version format
            local version=$(jq -r '.version // ""' "$feature_json")
            if [[ ! "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                print_status $RED "❌ Invalid version format in $feature_name: '$version'"
                issues_found=$((issues_found + 1))
                continue
            fi
            
            print_status $GREEN "✅ $feature_name: v$version"
        fi
    done
    
    if [ $issues_found -eq 0 ]; then
        print_status $GREEN "All versions are consistent and valid!"
    else
        print_status $RED "Found $issues_found version issues"
        return 1
    fi
}

# Function to create git commit and tags
create_version_commit() {
    local version_type=$1
    local features_updated="$2"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_status $RED "Not in a git repository"
        return 1
    fi
    
    # Check if there are changes to commit
    if [ -z "$(git status --porcelain src/*/devcontainer-feature.json)" ]; then
        print_status $YELLOW "No version changes to commit"
        return 0
    fi
    
    print_status $BLUE "Creating version commit..."
    
    # Stage changes
    git add src/*/devcontainer-feature.json
    
    # Create commit message
    local commit_message="chore: bump versions ($version_type)

Updated features: $features_updated

Version bump type: $version_type
Created by: manual version script"
    
    # Commit changes
    git commit -m "$commit_message"
    
    # Create repository version tag
    local repo_version=$(date +"%Y.%m.%d")
    local existing_tag_count=$(git tag -l "${repo_version}*" | wc -l)
    if [ "$existing_tag_count" -gt 0 ]; then
        repo_version="${repo_version}.$existing_tag_count"
    fi
    
    git tag -a "v$repo_version" -m "Release v$repo_version

Version bump: $version_type
Features updated: $features_updated"
    
    print_status $GREEN "Created commit and tag: v$repo_version"
    print_status $YELLOW "Don't forget to push: git push origin main --tags"
}

# Main function
main() {
    cd "$REPO_ROOT"
    
    if [ $# -eq 0 ]; then
        show_help
        exit 1
    fi
    
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        list)
            list_features
            exit 0
            ;;
        check)
            check_versions
            exit $?
            ;;
        major|minor|patch)
            version_type=$1
            feature_name=${2:-""}
            ;;
        *)
            print_status $RED "Invalid command: $1"
            show_help
            exit 1
            ;;
    esac
    
    # Check dependencies
    if ! command -v jq >/dev/null 2>&1; then
        print_status $RED "jq is required but not installed"
        exit 1
    fi
    
    print_status $GREEN "DevContainer Features Version Management"
    print_status $GREEN "========================================"
    
    local updated_features=""
    local update_count=0
    
    if [ -n "$feature_name" ]; then
        # Update specific feature
        if [ ! -d "$FEATURES_DIR/$feature_name" ]; then
            print_status $RED "Feature not found: $feature_name"
            exit 1
        fi
        
        local new_version=$(update_feature_version "$feature_name" "$version_type")
        if [ $? -eq 0 ]; then
            updated_features="$feature_name:$new_version"
            update_count=1
        else
            exit 1
        fi
    else
        # Update all features
        print_status $YELLOW "Updating all features with $version_type version bump..."
        
        for feature_dir in "$FEATURES_DIR"/*; do
            if [ -d "$feature_dir" ]; then
                local feature=$(basename "$feature_dir")
                local new_version=$(update_feature_version "$feature" "$version_type")
                if [ $? -eq 0 ]; then
                    if [ -n "$updated_features" ]; then
                        updated_features="$updated_features, $feature:$new_version"
                    else
                        updated_features="$feature:$new_version"
                    fi
                    update_count=$((update_count + 1))
                fi
            fi
        done
    fi
    
    if [ $update_count -eq 0 ]; then
        print_status $RED "No features were updated"
        exit 1
    fi
    
    print_status $GREEN "Successfully updated $update_count feature(s)"
    print_status $GREEN "Updated: $updated_features"
    
    # Ask if user wants to commit changes
    if git rev-parse --git-dir > /dev/null 2>&1; then
        read -p "Create git commit and tags? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            create_version_commit "$version_type" "$updated_features"
        fi
    fi
}

main "$@"