#!/bin/bash

set -e

source dev-container-features-test-lib

# Change to the source directory where install.sh is located
FEATURE_DIR="/tmp/dev-container-features/alpine-docker-outside-of-docker_0"
if [ -d "$FEATURE_DIR" ]; then
    cd "$FEATURE_DIR"
elif [ -f "../install.sh" ]; then
    cd ".."
elif [ -f "./install.sh" ]; then
    # Already in correct directory
    true
else
    # Look for install.sh in likely locations
    if [ -f "/workspaces/features/src/alpine-docker-outside-of-docker/install.sh" ]; then
        cd "/workspaces/features/src/alpine-docker-outside-of-docker"
    elif [ -f "./src/alpine-docker-outside-of-docker/install.sh" ]; then
        cd "./src/alpine-docker-outside-of-docker"
    fi
fi

# Test that the script exists and is executable
check "install script exists" test -f ./install.sh
check "install script is executable" test -x ./install.sh

# Test that the script has proper shebang
check "script has shebang" head -n 1 ./install.sh | grep -q "#!/bin/sh"

# Test basic script syntax by parsing it (without executing package operations)
check "script syntax is valid" sh -n ./install.sh

# Test that required functions are defined
check "check_packages function exists" grep -q "check_packages" ./install.sh
check "check_docker_version function exists" grep -q "check_docker_version" ./install.sh

# Test that script handles environment variables properly
check "script references VERSION variable" grep -q "\${VERSION" ./install.sh
check "script references DOCKERDASHCOMPOSEVERSION" grep -q "\${DOCKERDASHCOMPOSEVERSION" ./install.sh
check "script references INSTALLDOCKERBUILDX" grep -q "\${INSTALLDOCKERBUILDX" ./install.sh

# Test that the script contains Alpine-specific commands
check "script uses apk package manager" grep -q "apk add" ./install.sh
check "script uses apk update" grep -q "apk update" ./install.sh

# Test that docker-init script creation is included
check "script creates docker-init" grep -q "/usr/local/share/docker-init.sh" ./install.sh

# Test that socat is installed for socket forwarding
check "script installs socat" grep -q "socat" ./install.sh

# Test that script handles user management
check "script manages docker group" grep -q "docker.*group\|group.*docker" ./install.sh

# Test that script handles different compose versions
check "script handles compose v1" grep -q "compose.*v1\|v1.*compose" ./install.sh
check "script handles compose v2" grep -q "compose.*v2\|v2.*compose" ./install.sh

# Test Docker CLI installation logic
check "script installs docker-cli" grep -q "docker-cli" ./install.sh

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
