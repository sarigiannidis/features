#!/bin/sh

# Script to generate a new DevContainer feature template
# Usage: ./scripts/create-feature.sh <feature-name> [description]

set -e
#!/bin/sh

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
FEATURES_DIR="$REPO_ROOT/src"
TEST_DIR="$REPO_ROOT/test"

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    color=$1
    message=$2
    echo -e "${color}${message}${NC}"
}

show_help() {
    cat << EOF
DevContainer Feature Generator

Usage: $0 <feature-name> [description]

Arguments:
  feature-name    Required. Name of the feature (e.g., alpine-rust)
  description     Optional. Description of the feature

Examples:
  $0 alpine-rust "Install Rust on Alpine Linux"
  $0 alpine-go

EOF
}

create_feature_json() {
    feature_name=$1
    description=$2
    feature_dir="$FEATURES_DIR/$feature_name"
    
    cat > "$feature_dir/devcontainer-feature.json" << EOF
{
    "name": "$description",
    "id": "$feature_name",
    "version": "1.0.0",
    "description": "$description",
    "options": {
        "version": {
            "type": "string",
            "default": "latest",
            "description": "Version to install"
        }
    },
    "installsAfter": [
        "ghcr.io/sarigiannidis/features/alpine-bash"
    ]
}
EOF
}

create_install_script() {
    feature_name=$1
    feature_dir="$FEATURES_DIR/$feature_name"
    
    cat > "$feature_dir/install.sh" << 'EOF'
#!/bin/sh
set -e

echo "Activating feature 'FEATURE_NAME'"

# Get the version option
VERSION=${VERSION:-"latest"}

echo "Installing version: $VERSION"

echo "Updating repository indexes"
apk update

echo "Adding required packages"
# TODO: Add your package installation commands here
# apk add your-package

echo "Feature 'FEATURE_NAME' installed successfully"
EOF
    
    # Replace FEATURE_NAME placeholder
    sed -i "s/FEATURE_NAME/$feature_name/g" "$feature_dir/install.sh"
    chmod +x "$feature_dir/install.sh"
}

create_readme() {
    feature_name=$1
    description=$2
    feature_dir="$FEATURES_DIR/$feature_name"
    
    cat > "$feature_dir/README.md" << EOF
# $description

$description for Alpine Linux containers.

## Example Usage

\`\`\`json
{
    "features": {
        "ghcr.io/sarigiannidis/features/$feature_name:latest": {
            "version": "latest"
        }
    }
}
\`\`\`

## Options

| Option | Description | Default |
|--------|-------------|---------|
| version | Version to install | latest |

## Supported Platforms

- linux/amd64
- linux/arm64

---

_Note: This Feature is published to ghcr.io/sarigiannidis/features._
EOF
}

create_test_script() {
    feature_name=$1
    test_dir="$TEST_DIR/$feature_name"
    
    mkdir -p "$test_dir"
    
    cat > "$test_dir/test.sh" << 'EOF'
#!/bin/bash

set -e

source dev-container-features-test-lib

# TODO: Add your test commands here
# Example tests:
# check "command exists" which your-command
# check "version check" your-command --version

# Test basic functionality
check "feature installed" echo "Add your actual tests here"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
EOF
    
    chmod +x "$test_dir/test.sh"
}

create_scenarios_json() {
    feature_name=$1
    test_dir="$TEST_DIR/$feature_name"
    
    cat > "$test_dir/scenarios.json" << EOF
{
    "$feature_name": {
        "image": "alpine:latest",
        "features": {
            "$feature_name": {
                "version": "latest"
            }
        }
    },
    "${feature_name}_specific_version": {
        "image": "alpine:latest", 
        "features": {
            "$feature_name": {
                "version": "1.0.0"
            }
        }
    }
}
EOF
}

main() {
    if [ $# -eq 0 ]; then
        show_help
        exit 1
    fi
    
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        show_help
        exit 0
    fi
    
    feature_name=$1
    description=${2:-"$feature_name on alpine"}
    
    # Validate feature name
    if [ "$feature_name" = "${feature_name#alpine-}" ]; then
        print_status $RED "Feature name should start with 'alpine-'"
        exit 1
    fi
    
    feature_dir="$FEATURES_DIR/$feature_name"
    test_dir="$TEST_DIR/$feature_name"
    
    # Check if feature already exists
    if [ -d "$feature_dir" ]; then
        print_status $RED "Feature '$feature_name' already exists!"
        exit 1
    fi
    
    print_status $YELLOW "Creating new feature: $feature_name"
    print_status $YELLOW "Description: $description"
    
    # Create directories
    mkdir -p "$feature_dir"
    mkdir -p "$test_dir"
    
    # Create files
    print_status $YELLOW "Creating devcontainer-feature.json..."
    create_feature_json "$feature_name" "$description"
    
    print_status $YELLOW "Creating install.sh..."
    create_install_script "$feature_name"
    
    print_status $YELLOW "Creating README.md..."
    create_readme "$feature_name" "$description"
    
    print_status $YELLOW "Creating test script..."
    create_test_script "$feature_name"
    
    print_status $YELLOW "Creating scenarios.json..."
    create_scenarios_json "$feature_name"
    
    print_status $GREEN "✅ Feature '$feature_name' created successfully!"
    print_status $GREEN ""
    print_status $GREEN "Next steps:"
    print_status $GREEN "1. Edit $feature_dir/install.sh to add package installation"
    print_status $GREEN "2. Edit $test_dir/test.sh to add proper tests"
    print_status $GREEN "3. Update $feature_dir/README.md with usage details"
    print_status $GREEN "4. Test locally: ./scripts/test-local.sh $feature_name"
}

main "$@"
