#!/bin/bash

# DevContainer Features Changelog Generator
# Generates changelog entries from git history and version changes

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

print_status() {
    printf "${1}%s${NC}\n" "$2"
}

show_help() {
    cat << EOF
DevContainer Features Changelog Generator

USAGE:
    $0 [options]

OPTIONS:
    --since TAG     Generate changelog since specific tag (default: latest tag)
    --output FILE   Output file (default: CHANGELOG.md)
    --format FORMAT Output format: markdown, json (default: markdown)
    --help          Show this help message

EXAMPLES:
    # Generate changelog since last tag
    $0
    
    # Generate changelog since specific version
    $0 --since v2023.01.01
    
    # Output to specific file
    $0 --output RELEASE_NOTES.md

EOF
}

# Function to get latest tag
get_latest_tag() {
    git describe --tags --abbrev=0 2>/dev/null || echo ""
}

# Function to get commits since tag
get_commits_since() {
    local since_ref=$1
    if [ -n "$since_ref" ]; then
        git log --oneline --pretty=format:"%H|%s|%an|%ad" --date=short "${since_ref}..HEAD"
    else
        git log --oneline --pretty=format:"%H|%s|%an|%ad" --date=short
    fi
}

# Function to categorize commit
categorize_commit() {
    local commit_message=$1
    
    if echo "$commit_message" | grep -qiE "(feat!|BREAKING CHANGE|^[^:]+!)"; then
        echo "breaking"
    elif echo "$commit_message" | grep -qE "^feat(\([^)]*\))?:"; then
        echo "features"
    elif echo "$commit_message" | grep -qE "^fix(\([^)]*\))?:"; then
        echo "fixes"
    elif echo "$commit_message" | grep -qE "^docs(\([^)]*\))?:"; then
        echo "documentation"
    elif echo "$commit_message" | grep -qE "^chore(\([^)]*\))?:"; then
        echo "maintenance"
    elif echo "$commit_message" | grep -qE "^test(\([^)]*\))?:"; then
        echo "tests"
    elif echo "$commit_message" | grep -qE "^ci(\([^)]*\))?:"; then
        echo "ci"
    else
        echo "other"
    fi
}

# Function to extract feature name from commit
extract_feature() {
    local commit_message=$1
    
    # Look for feature name in parentheses
    if echo "$commit_message" | grep -qE "^[^:]+\([^)]*\):"; then
        echo "$commit_message" | sed -E 's/^[^:]+\(([^)]*)\):.*/\1/'
    else
        echo ""
    fi
}

# Function to generate markdown changelog
generate_markdown_changelog() {
    local since_ref=$1
    local output_file=$2
    
    local current_date=$(date +"%Y-%m-%d")
    local version_info=""
    
    # Try to determine version
    if [ -n "$since_ref" ]; then
        version_info=" (since $since_ref)"
    fi
    
    cat > "$output_file" << EOF
# Changelog

## [Unreleased]$version_info - $current_date

### 🚨 Breaking Changes

EOF
    
    local commits=$(get_commits_since "$since_ref")
    
    # Process breaking changes
    echo "$commits" | while IFS='|' read -r hash message author date; do
        local category=$(categorize_commit "$message")
        if [ "$category" = "breaking" ]; then
            echo "- $message ($hash)" >> "$output_file"
        fi
    done
    
    cat >> "$output_file" << EOF

### ✨ New Features

EOF
    
    # Process new features
    echo "$commits" | while IFS='|' read -r hash message author date; do
        local category=$(categorize_commit "$message")
        if [ "$category" = "features" ]; then
            local feature=$(extract_feature "$message")
            if [ -n "$feature" ]; then
                echo "- **$feature**: $message ($hash)" >> "$output_file"
            else
                echo "- $message ($hash)" >> "$output_file"
            fi
        fi
    done
    
    cat >> "$output_file" << EOF

### 🐛 Bug Fixes

EOF
    
    # Process bug fixes
    echo "$commits" | while IFS='|' read -r hash message author date; do
        local category=$(categorize_commit "$message")
        if [ "$category" = "fixes" ]; then
            local feature=$(extract_feature "$message")
            if [ -n "$feature" ]; then
                echo "- **$feature**: $message ($hash)" >> "$output_file"
            else
                echo "- $message ($hash)" >> "$output_file"
            fi
        fi
    done
    
    cat >> "$output_file" << EOF

### 📚 Documentation

EOF
    
    # Process documentation changes
    echo "$commits" | while IFS='|' read -r hash message author date; do
        local category=$(categorize_commit "$message")
        if [ "$category" = "documentation" ]; then
            echo "- $message ($hash)" >> "$output_file"
        fi
    done
    
    cat >> "$output_file" << EOF

### 🔧 Maintenance

EOF
    
    # Process maintenance changes
    echo "$commits" | while IFS='|' read -r hash message author date; do
        local category=$(categorize_commit "$message")
        if [ "$category" = "maintenance" ] || [ "$category" = "tests" ] || [ "$category" = "ci" ]; then
            echo "- $message ($hash)" >> "$output_file"
        fi
    done
    
    cat >> "$output_file" << EOF

### 📦 Feature Versions

Current feature versions:

EOF
    
    # Add current feature versions
    if [ -f "$REPO_ROOT/scripts/bump-version.sh" ]; then
        "$REPO_ROOT/scripts/bump-version.sh" list | while read -r line; do
            if echo "$line" | grep -q "^alpine-"; then
                echo "- $line" >> "$output_file"
            fi
        done
    fi
    
    echo "" >> "$output_file"
    echo "---" >> "$output_file"
    echo "" >> "$output_file"
    echo "*Generated on $current_date*" >> "$output_file"
}

# Function to generate JSON changelog
generate_json_changelog() {
    local since_ref=$1
    local output_file=$2
    
    local current_date=$(date +"%Y-%m-%d")
    local commits=$(get_commits_since "$since_ref")
    
    echo "{" > "$output_file"
    echo "  \"generated\": \"$current_date\"," >> "$output_file"
    echo "  \"since\": \"$since_ref\"," >> "$output_file"
    echo "  \"changes\": {" >> "$output_file"
    
    # Process each category
    local categories=("breaking" "features" "fixes" "documentation" "maintenance")
    
    for i in "${!categories[@]}"; do
        local cat=${categories[$i]}
        echo "    \"$cat\": [" >> "$output_file"
        
        local first=true
        echo "$commits" | while IFS='|' read -r hash message author date; do
            local commit_category=$(categorize_commit "$message")
            if [ "$commit_category" = "$cat" ] || \
               ([ "$cat" = "maintenance" ] && ([ "$commit_category" = "tests" ] || [ "$commit_category" = "ci" ])); then
                if [ "$first" = "false" ]; then
                    echo "," >> "$output_file"
                fi
                echo "      {" >> "$output_file"
                echo "        \"hash\": \"$hash\"," >> "$output_file"
                echo "        \"message\": \"$message\"," >> "$output_file"
                echo "        \"author\": \"$author\"," >> "$output_file"
                echo "        \"date\": \"$date\"" >> "$output_file"
                echo -n "      }" >> "$output_file"
                first=false
            fi
        done
        
        echo "" >> "$output_file"
        echo "    ]" >> "$output_file"
        if [ $i -lt $((${#categories[@]} - 1)) ]; then
            echo "," >> "$output_file"
        fi
    done
    
    echo "  }" >> "$output_file"
    echo "}" >> "$output_file"
}

# Main function
main() {
    local since_ref=""
    local output_file="CHANGELOG.md"
    local format="markdown"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --since)
                since_ref="$2"
                shift 2
                ;;
            --output)
                output_file="$2"
                shift 2
                ;;
            --format)
                format="$2"
                shift 2
                ;;
            --help|-h)
                show_help
                exit 0
                ;;
            *)
                print_status $RED "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    cd "$REPO_ROOT"
    
    # Check if we're in a git repository
    if ! git rev-parse --git-dir > /dev/null 2>&1; then
        print_status $RED "Not in a git repository"
        exit 1
    fi
    
    # Use latest tag if no since_ref provided
    if [ -z "$since_ref" ]; then
        since_ref=$(get_latest_tag)
        if [ -z "$since_ref" ]; then
            print_status $YELLOW "No tags found, generating changelog from beginning of history"
        else
            print_status $BLUE "Generating changelog since: $since_ref"
        fi
    fi
    
    print_status $GREEN "DevContainer Features Changelog Generator"
    print_status $GREEN "========================================"
    
    case $format in
        markdown)
            generate_markdown_changelog "$since_ref" "$output_file"
            ;;
        json)
            generate_json_changelog "$since_ref" "$output_file"
            ;;
        *)
            print_status $RED "Unsupported format: $format"
            exit 1
            ;;
    esac
    
    print_status $GREEN "Changelog generated: $output_file"
    
    if [ "$format" = "markdown" ]; then
        print_status $BLUE "Preview:"
        head -20 "$output_file"
        if [ $(wc -l < "$output_file") -gt 20 ]; then
            print_status $YELLOW "... (output truncated, see $output_file for full changelog)"
        fi
    fi
}

main "$@"