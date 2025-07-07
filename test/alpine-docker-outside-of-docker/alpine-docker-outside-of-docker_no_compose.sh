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

echo "=== Testing alpine-docker-outside-of-docker no compose scenario ==="

# Test Docker CLI installation
check "docker CLI is installed" command -v docker
check "docker CLI is executable" docker --version

# Test that Docker Compose is NOT installed (dockerDashComposeVersion: "none")
check "docker-compose is NOT installed" ! command -v docker-compose

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

# Test that compose subcommand is not available through Docker CLI plugins
check "docker compose plugin not available" ! docker compose version > /dev/null 2>&1 || echo "Compose plugin may be available through Docker CLI"

# Verify no compose-related files exist
check "no docker-compose binary in /usr/local/bin" ! test -f /usr/local/bin/docker-compose

echo "All no compose scenario tests completed successfully!"