#!/bin/bash

# DevContainer Features Version Consistency Checker
# Validates version formats and consistency across features

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
DevContainer Features Version Consistency Checker

USAGE:
    $0 [options]

OPTIONS:
    --fix           Automatically fix common version issues
    --verbose       Show detailed output
    --format        Check and enforce version format only
    --help          Show this help message

EXAMPLES:
    # Check all versions
    $0
    
    # Check and fix issues automatically
    $0 --fix
    
    # Verbose output with details
    $0 --verbose

EOF
}

# Function to validate semantic version format
validate_semver() {
    local version=$1
    if [[ "$version" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
        return 0
    else
        return 1
    fi
}

# Function to normalize version (e.g., add .0 if needed)
normalize_version() {
    local version=$1
    
    # If version is just a number, make it x.0.0
    if [[ "$version" =~ ^[0-9]+$ ]]; then
        echo "$version.0.0"
        return 0
    fi
    
    # If version is x.y, make it x.y.0
    if [[ "$version" =~ ^[0-9]+\.[0-9]+$ ]]; then
        echo "$version.0"
        return 0
    fi
    
    # Return as-is if already in correct format
    if validate_semver "$version"; then
        echo "$version"
        return 0
    fi
    
    # Invalid format
    return 1
}

# Function to check single feature
check_feature() {
    local feature_name=$1
    local fix_mode=$2
    local verbose=$3
    local feature_dir="$FEATURES_DIR/$feature_name"
    local feature_json="$feature_dir/devcontainer-feature.json"
    local issues=0
    
    if [ "$verbose" = "true" ]; then
        print_status $BLUE "Checking feature: $feature_name"
    fi
    
    # Check if JSON file exists
    if [ ! -f "$feature_json" ]; then
        print_status $RED "❌ Missing devcontainer-feature.json: $feature_name"
        return 1
    fi
    
    # Check JSON validity
    if ! jq empty "$feature_json" 2>/dev/null; then
        print_status $RED "❌ Invalid JSON syntax: $feature_name"
        return 1
    fi
    
    # Get current version
    local version=$(jq -r '.version // ""' "$feature_json")
    
    # Check if version exists
    if [ -z "$version" ] || [ "$version" = "null" ]; then
        print_status $RED "❌ Missing version field: $feature_name"
        
        if [ "$fix_mode" = "true" ]; then
            print_status $YELLOW "🔧 Adding default version 1.0.0 to $feature_name"
            jq '.version = "1.0.0"' "$feature_json" > "${feature_json}.tmp"
            mv "${feature_json}.tmp" "$feature_json"
            version="1.0.0"
        else
            issues=$((issues + 1))
        fi
    fi
    
    # Validate version format
    if [ -n "$version" ] && [ "$version" != "null" ]; then
        if ! validate_semver "$version"; then
            local normalized_version=$(normalize_version "$version" 2>/dev/null || echo "")
            
            if [ -n "$normalized_version" ]; then
                print_status $YELLOW "⚠️  Invalid version format in $feature_name: '$version'"
                
                if [ "$fix_mode" = "true" ]; then
                    print_status $YELLOW "🔧 Normalizing version in $feature_name: $version → $normalized_version"
                    jq --arg version "$normalized_version" '.version = $version' "$feature_json" > "${feature_json}.tmp"
                    mv "${feature_json}.tmp" "$feature_json"
                    version="$normalized_version"
                else
                    print_status $YELLOW "   Suggested fix: $normalized_version"
                    issues=$((issues + 1))
                fi
            else
                print_status $RED "❌ Cannot normalize version in $feature_name: '$version'"
                issues=$((issues + 1))
            fi
        fi
    fi
    
    # Check for required fields
    local id=$(jq -r '.id // ""' "$feature_json")
    local name=$(jq -r '.name // ""' "$feature_json")
    local description=$(jq -r '.description // ""' "$feature_json")
    
    if [ -z "$id" ] || [ "$id" = "null" ]; then
        print_status $RED "❌ Missing id field: $feature_name"
        issues=$((issues + 1))
    elif [ "$id" != "$feature_name" ]; then
        print_status $YELLOW "⚠️  ID mismatch in $feature_name: '$id' (expected '$feature_name')"
        
        if [ "$fix_mode" = "true" ]; then
            print_status $YELLOW "🔧 Fixing ID in $feature_name: $id → $feature_name"
            jq --arg id "$feature_name" '.id = $id' "$feature_json" > "${feature_json}.tmp"
            mv "${feature_json}.tmp" "$feature_json"
        else
            issues=$((issues + 1))
        fi
    fi
    
    if [ -z "$name" ] || [ "$name" = "null" ]; then
        print_status $RED "❌ Missing name field: $feature_name"
        issues=$((issues + 1))
    fi
    
    if [ -z "$description" ] || [ "$description" = "null" ]; then
        print_status $RED "❌ Missing description field: $feature_name"
        issues=$((issues + 1))
    fi
    
    # Check install.sh
    local install_script="$feature_dir/install.sh"
    if [ ! -f "$install_script" ]; then
        print_status $RED "❌ Missing install.sh: $feature_name"
        issues=$((issues + 1))
    elif [ ! -x "$install_script" ]; then
        print_status $YELLOW "⚠️  install.sh not executable: $feature_name"
        
        if [ "$fix_mode" = "true" ]; then
            print_status $YELLOW "🔧 Making install.sh executable: $feature_name"
            chmod +x "$install_script"
        else
            issues=$((issues + 1))
        fi
    fi
    
    # Check install.sh syntax
    if [ -f "$install_script" ]; then
        if ! bash -n "$install_script" 2>/dev/null; then
            print_status $RED "❌ Syntax error in install.sh: $feature_name"
            issues=$((issues + 1))
        fi
    fi
    
    if [ $issues -eq 0 ] && [ "$verbose" = "true" ]; then
        print_status $GREEN "✅ $feature_name: v$version (all checks passed)"
    elif [ $issues -eq 0 ]; then
        print_status $GREEN "✅ $feature_name: v$version"
    fi
    
    return $issues
}

# Function to generate version report
generate_report() {
    local verbose=$1
    
    print_status $BLUE "Generating version report..."
    
    local report_file="$REPO_ROOT/version-report.md"
    
    cat > "$report_file" << EOF
# Version Report

Generated on: $(date)

## Feature Versions

| Feature | Version | Status |
|---------|---------|--------|
EOF
    
    for feature_dir in "$FEATURES_DIR"/*; do
        if [ -d "$feature_dir" ]; then
            local feature_name=$(basename "$feature_dir")
            local feature_json="$feature_dir/devcontainer-feature.json"
            local status="❌ Missing"
            local version=""
            
            if [ -f "$feature_json" ]; then
                if jq empty "$feature_json" 2>/dev/null; then
                    version=$(jq -r '.version // "missing"' "$feature_json")
                    if validate_semver "$version"; then
                        status="✅ Valid"
                    else
                        status="⚠️ Invalid Format"
                    fi
                else
                    status="❌ Invalid JSON"
                fi
            fi
            
            echo "| $feature_name | $version | $status |" >> "$report_file"
        fi
    done
    
    cat >> "$report_file" << EOF

## Summary

- Total features: $(ls "$FEATURES_DIR" | wc -l)
- Valid versions: $(find "$FEATURES_DIR" -name "devcontainer-feature.json" -exec jq -r '.version // ""' {} \; 2>/dev/null | grep -E '^[0-9]+\.[0-9]+\.[0-9]+$' | wc -l)
- Report generated by: version check script

EOF
    
    print_status $GREEN "Report saved to: $report_file"
}

# Main function
main() {
    local fix_mode="false"
    local verbose="false"
    local format_only="false"
    local generate_report_flag="false"
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            --fix)
                fix_mode="true"
                shift
                ;;
            --verbose)
                verbose="true"
                shift
                ;;
            --format)
                format_only="true"
                shift
                ;;
            --report)
                generate_report_flag="true"
                shift
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
    
    # Check dependencies
    if ! command -v jq >/dev/null 2>&1; then
        print_status $RED "jq is required but not installed"
        exit 1
    fi
    
    print_status $GREEN "DevContainer Features Version Checker"
    print_status $GREEN "====================================="
    
    if [ "$fix_mode" = "true" ]; then
        print_status $YELLOW "Running in fix mode - issues will be automatically corrected"
    fi
    
    local total_features=0
    local total_issues=0
    local features_with_issues=0
    
    # Check each feature
    for feature_dir in "$FEATURES_DIR"/*; do
        if [ -d "$feature_dir" ]; then
            local feature_name=$(basename "$feature_dir")
            total_features=$((total_features + 1))
            
            local feature_issues=$(check_feature "$feature_name" "$fix_mode" "$verbose")
            local feature_issue_count=$?
            
            if [ $feature_issue_count -gt 0 ]; then
                total_issues=$((total_issues + feature_issue_count))
                features_with_issues=$((features_with_issues + 1))
            fi
        fi
    done
    
    # Generate report if requested
    if [ "$generate_report_flag" = "true" ]; then
        generate_report "$verbose"
    fi
    
    # Summary
    print_status $GREEN "======================================="
    print_status $GREEN "Summary:"
    print_status $GREEN "Total features: $total_features"
    print_status $GREEN "Features with issues: $features_with_issues"
    print_status $GREEN "Total issues: $total_issues"
    
    if [ $total_issues -eq 0 ]; then
        print_status $GREEN "🎉 All features have valid versions!"
        exit 0
    else
        if [ "$fix_mode" = "true" ]; then
            print_status $YELLOW "Fixed $total_issues issues across $features_with_issues features"
            
            # Check if any files were changed
            if [ -n "$(git status --porcelain src/*/devcontainer-feature.json 2>/dev/null || echo '')" ]; then
                print_status $YELLOW "Changes were made to feature files. Don't forget to commit them:"
                print_status $YELLOW "  git add src/*/devcontainer-feature.json"
                print_status $YELLOW "  git commit -m 'fix: normalize feature versions'"
            fi
        else
            print_status $RED "❌ Found $total_issues issues across $features_with_issues features"
            print_status $YELLOW "Run with --fix to automatically correct issues"
            exit 1
        fi
    fi
}

main "$@"