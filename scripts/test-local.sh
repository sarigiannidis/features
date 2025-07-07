#!/bin/bash

# Local testing script for DevContainer features
# Usage: ./scripts/test-local.sh [feature-name]

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FEATURES_DIR="$REPO_ROOT/src"
TEST_DIR="$REPO_ROOT/test"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to test a single feature
test_feature() {
    local feature_name=$1
    print_status $YELLOW "Testing feature: $feature_name"
    
    # Check if feature exists
    if [ ! -d "$FEATURES_DIR/$feature_name" ]; then
        print_status $RED "Feature '$feature_name' not found in $FEATURES_DIR"
        return 1
    fi
    
    # Check if test exists
    if [ ! -f "$TEST_DIR/$feature_name/test.sh" ]; then
        print_status $YELLOW "No test script found for '$feature_name', skipping..."
        return 0
    fi
    
    # Run the test using devcontainer CLI
    print_status $YELLOW "Running test for $feature_name..."
    
    cd "$TEST_DIR/$feature_name"
    
    if command -v devcontainer >/dev/null 2>&1; then
        # Use devcontainer CLI if available
        if devcontainer features test --features "$FEATURES_DIR" --test-folder . --log-level info; then
            print_status $GREEN "✓ Test passed for $feature_name"
            return 0
        else
            print_status $RED "✗ Test failed for $feature_name"
            return 1
        fi
    else
        print_status $RED "DevContainer CLI not found. Please install it with: npm install -g @devcontainers/cli"
        return 1
    fi
}

# Function to validate feature structure
validate_feature() {
    local feature_name=$1
    local feature_dir="$FEATURES_DIR/$feature_name"
    
    print_status $YELLOW "Validating feature structure: $feature_name"
    
    # Check required files
    if [ ! -f "$feature_dir/devcontainer-feature.json" ]; then
        print_status $RED "Missing devcontainer-feature.json in $feature_name"
        return 1
    fi
    
    if [ ! -f "$feature_dir/install.sh" ]; then
        print_status $RED "Missing install.sh in $feature_name"
        return 1
    fi
    
    # Validate JSON syntax
    if ! jq . "$feature_dir/devcontainer-feature.json" >/dev/null 2>&1; then
        print_status $RED "Invalid JSON syntax in $feature_name/devcontainer-feature.json"
        return 1
    fi
    
    # Check if install.sh is executable
    if [ ! -x "$feature_dir/install.sh" ]; then
        print_status $YELLOW "Making install.sh executable for $feature_name"
        chmod +x "$feature_dir/install.sh"
    fi
    
    print_status $GREEN "✓ Feature structure valid for $feature_name"
    return 0
}

# Main execution
main() {
    cd "$REPO_ROOT"
    
    print_status $GREEN "DevContainer Features Local Testing Script"
    print_status $GREEN "=========================================="
    
    # Check dependencies
    if ! command -v jq >/dev/null 2>&1; then
        print_status $RED "jq is required but not installed. Please install it."
        exit 1
    fi
    
    local failed_tests=0
    local total_tests=0
    
    if [ $# -eq 0 ]; then
        # Test all features
        print_status $YELLOW "Testing all features..."
        
        for feature_dir in "$FEATURES_DIR"/*; do
            if [ -d "$feature_dir" ]; then
                feature_name=$(basename "$feature_dir")
                total_tests=$((total_tests + 1))
                
                # Validate feature structure first
                if ! validate_feature "$feature_name"; then
                    failed_tests=$((failed_tests + 1))
                    continue
                fi
                
                # Run tests
                if ! test_feature "$feature_name"; then
                    failed_tests=$((failed_tests + 1))
                fi
            fi
        done
    else
        # Test specific feature
        feature_name=$1
        total_tests=1
        
        if ! validate_feature "$feature_name"; then
            failed_tests=1
        elif ! test_feature "$feature_name"; then
            failed_tests=1
        fi
    fi
    
    # Summary
    print_status $GREEN "=========================================="
    print_status $GREEN "Test Summary:"
    print_status $GREEN "Total features tested: $total_tests"
    print_status $GREEN "Passed: $((total_tests - failed_tests))"
    
    if [ $failed_tests -eq 0 ]; then
        print_status $GREEN "Failed: $failed_tests"
        print_status $GREEN "🎉 All tests passed!"
        exit 0
    else
        print_status $RED "Failed: $failed_tests"
        print_status $RED "❌ Some tests failed!"
        exit 1
    fi
}

# Help function
show_help() {
    cat << EOF
DevContainer Features Local Testing Script

Usage: $0 [feature-name]

Arguments:
  feature-name    Optional. Test only the specified feature.
                  If not provided, all features will be tested.

Examples:
  $0                    # Test all features
  $0 alpine-git         # Test only the alpine-git feature
  $0 alpine-node        # Test only the alpine-node feature

Requirements:
  - DevContainer CLI (npm install -g @devcontainers/cli)
  - jq
  - Docker

EOF
}

# Check for help flag
if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    show_help
    exit 0
fi

# Run main function
main "$@"
