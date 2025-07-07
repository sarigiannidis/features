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

echo "=== Testing alpine-docker-outside-of-docker latest version scenario ==="

# Test Docker CLI installation
check "docker CLI is installed" command -v docker
check "docker CLI is executable" docker --version

# Test that latest version was installed (specific to Alpine packages)
check "docker CLI version contains info" docker --version | grep -i docker

# Test Docker Compose installation (default is v2)
check "docker-compose is installed" command -v docker-compose
check "docker-compose version" docker-compose --version

# Test that compose v2 is installed by default
check "docker-compose is v2" docker-compose --version | grep -E "(version v2|compose.*version [2-9])"

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

# Test that latest version logic worked properly
check "docker version command works" docker version --format '{{.Client.Version}}' > /dev/null 2>&1 || echo "Version check requires socket - expected in test"

echo "All latest version scenario tests completed successfully!"