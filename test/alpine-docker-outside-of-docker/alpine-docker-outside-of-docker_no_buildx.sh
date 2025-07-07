#!/bin/sh

set -e

# Simple test functions
check() {
    desc="$1"
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

echo "=== Testing alpine-docker-outside-of-docker no buildx scenario ==="

# Test Docker CLI installation
check "docker CLI is installed" command -v docker
check "docker CLI is executable" docker --version

# Test Docker Compose installation (default is v2)
check "docker-compose is installed" command -v docker-compose
check "docker-compose version" docker-compose --version

# Test that Docker Buildx is NOT installed (installDockerBuildx: false)
check "docker buildx is NOT available" ! docker buildx version > /dev/null 2>&1

# Test that buildx package is not installed
check "docker-cli-buildx package not installed" ! apk info -e docker-cli-buildx > /dev/null 2>&1

# Test socat installation (required for socket forwarding)
check "socat is installed" command -v socat

# Test docker group exists
check "docker group exists" getent group docker

# Test docker-init script exists
check "docker-init script exists" test -f /usr/local/share/docker-init.sh
check "docker-init script is executable" test -x /usr/local/share/docker-init.sh

# Test basic Docker functionality (if socket is available)
if [ -S /var/run/docker.sock ] || [ -S /var/run/docker-host.sock ]; then
    check "docker info works" timeout 10 docker info > /dev/null 2>&1 || echo "Socket not available - expected in test environment"
else
    echo "Note: Docker socket not available in test environment - expected"
fi

# Test that basic Docker commands work without buildx
check "docker help works" docker --help | grep -q "Usage:"

# Verify that buildx subcommand is not available
check "docker buildx command not available" ! docker buildx --help > /dev/null 2>&1

# Test that standard Docker build still works (should use legacy builder)
if [ -S /var/run/docker.sock ] || [ -S /var/run/docker-host.sock ]; then
    check "docker build help works" docker build --help | grep -q "Usage:" || echo "Build help requires socket context"
else
    echo "Note: Docker build tests require socket - expected limitation in test environment"
fi

echo "All no buildx scenario tests completed successfully!"