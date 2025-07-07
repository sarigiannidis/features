#!/bin/bash

set -e

source dev-container-features-test-lib

# Test that Docker CLI is installed
check "docker command exists" which docker
check "docker version command" docker --version
check "docker version format" docker --version | grep -E "Docker version [0-9]+\.[0-9]+\.[0-9]+"

# Test that docker-compose is installed (if enabled)
check "docker-compose command exists" which docker-compose
check "docker-compose version command" docker-compose --version

# Test that Docker Buildx is installed (if enabled)
check "docker buildx command exists" docker buildx version

# Test that the docker group exists
check "docker group exists" getent group docker

# Test that docker init script exists
check "docker-init script exists" test -f /usr/local/share/docker-init.sh
check "docker-init script is executable" test -x /usr/local/share/docker-init.sh

# Test that socat is available (for socket forwarding)
check "socat command exists" which socat

# Test basic Docker functionality (this will fail without actual Docker daemon, which is expected)
# We just test that the CLI can parse commands without errors
check "docker help works" docker --help | grep -q "Usage:"

# Test docker-compose functionality
check "docker-compose help works" docker-compose --help | grep -q "Usage:"

# Test buildx functionality  
check "docker buildx help works" docker buildx --help | grep -q "Usage:"

# Test that docker socket mount point exists
check "docker socket target exists" test -e /var/run/docker.sock

# Test environment variables are correctly set
check "USERNAME variable set" test -n "$_REMOTE_USER" || test "$USERNAME" = "root"

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
