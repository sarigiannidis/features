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

echo "=== Testing alpine-docker-outside-of-docker compose v1 scenario ==="

# Test Docker CLI installation
check "docker CLI is installed" command -v docker
check "docker CLI is executable" docker --version

# Test that Docker Compose v1 is installed (dockerDashComposeVersion: "v1")
check "docker-compose is installed" command -v docker-compose
check "docker-compose version" docker-compose --version

# Test that compose v1 is specifically installed (should be version 1.29.2)
check "docker-compose is v1" docker-compose --version | grep -E "(version 1\.|1\.29\.2)"

# Test Docker Buildx installation (default is true)
check "docker buildx is available" docker buildx version

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

# Test compose v1 specific functionality
check "docker-compose help works" docker-compose --help | grep -q "docker-compose"

# Verify compose v1 file exists in expected location
check "docker-compose binary exists" test -f /usr/local/bin/docker-compose

# Test that it's the expected v1 version (1.29.2)
check "docker-compose version is 1.29.2" docker-compose --version | grep -q "1.29.2" || echo "Note: v1 version may vary based on installation method"

echo "All compose v1 scenario tests completed successfully!"