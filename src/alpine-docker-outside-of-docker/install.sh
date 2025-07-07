#!/bin/sh
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------
#
# Docs: https://github.com/microsoft/vscode-dev-containers/blob/main/script-library/docs/docker.md
# Maintainer: The VS Code and Codespaces Teams
# Adapted for Alpine Linux by sarigiannidis/features

DOCKER_VERSION="${VERSION:-"latest"}"
DOCKER_DASH_COMPOSE_VERSION="${DOCKERDASHCOMPOSEVERSION:-"v2"}" # v1 or v2 or none

ENABLE_NONROOT_DOCKER="${ENABLE_NONROOT_DOCKER:-"true"}"
SOURCE_SOCKET="${SOURCE_SOCKET:-"/var/run/docker-host.sock"}"
TARGET_SOCKET="${TARGET_SOCKET:-"/var/run/docker.sock"}"
USERNAME="${USERNAME:-"${_REMOTE_USER:-"automatic"}"}"
INSTALL_DOCKER_BUILDX="${INSTALLDOCKERBUILDX:-"true"}"

set -e

echo "Activating feature 'alpine-docker-outside-of-docker'"

# Setup STDERR.
err() {
    echo "(!) $*" >&2
}

if [ "$(id -u)" -ne 0 ]; then
    echo 'Script must be run as root. Use sudo, su, or add "USER root" to your Dockerfile before running this script.'
    exit 1
fi

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS="vscode node codespace $(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)"
    for CURRENT_USER in ${POSSIBLE_USERS}; do
        if id -u "${CURRENT_USER}" > /dev/null 2>&1; then
            USERNAME=${CURRENT_USER}
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u "${USERNAME}" > /dev/null 2>&1; then
    USERNAME=root
fi

# Checks if packages are installed and installs them if not
check_packages() {
    for pkg in "$@"; do
        if ! apk info -e "$pkg" > /dev/null 2>&1; then
            echo "Installing missing package: $pkg"
            apk add --no-cache "$pkg"
        fi
    done
}

# Simple version check for Alpine packages
check_docker_version() {
    if [ "${DOCKER_VERSION}" = "latest" ] || [ "${DOCKER_VERSION}" = "none" ]; then
        return 0
    fi
    # For Alpine, we mainly use what's available in the repos
    return 0
}

# Ensure we have basic requirements
check_packages curl wget ca-certificates

# Check Docker version
check_docker_version

# Fetch host/container arch.
architecture="$(uname -m)"

# Update apk indexes
echo "Updating repository indexes"
apk update

# Install Docker CLI if not already installed
if type docker > /dev/null 2>&1; then
    echo "Docker CLI already installed."
else
    echo "Installing Docker CLI..."
    
    # Install Docker from Alpine's community repository
    apk add --no-cache docker-cli
    
    # Install docker-compose if needed
    if [ "${DOCKER_DASH_COMPOSE_VERSION}" != "none" ]; then
        case "${architecture}" in
            x86_64) target_compose_arch=x86_64 ;;
            aarch64) target_compose_arch=aarch64 ;;
            *)
                echo "(!) Docker outside of docker does not support machine architecture '$architecture'. Please use an x86-64 or ARM64 machine."
                exit 1
        esac
        
        docker_compose_path="/usr/local/bin/docker-compose"
        
        if type docker-compose > /dev/null 2>&1; then
            echo "Docker Compose already installed."
        elif [ "${DOCKER_DASH_COMPOSE_VERSION}" = "v1" ]; then
            err "The final Compose V1 release, version 1.29.2, was May 10, 2021. These packages haven't received any security updates since then. Use at your own risk."
            
            if [ "${target_compose_arch}" = "x86_64" ]; then
                echo "(*) Installing docker compose v1..."
                wget -O ${docker_compose_path} "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64"
                chmod +x ${docker_compose_path}
            else
                # Use pip to get a version that runs on this architecture
                check_packages python3 py3-pip python3-dev libffi-dev
                echo "(*) Installing docker compose v1 via pip..."
                pip3 install --break-system-packages docker-compose==1.29.2
            fi
        else
            # Install latest compose v2
            if [ "${DOCKER_VERSION}" = "latest" ]; then
                compose_version="latest"
            else
                compose_version="2.20.0"  # Default fallback version
            fi
            
            echo "(*) Installing docker-compose ${compose_version}..."
            
            if [ "${compose_version}" = "latest" ]; then
                # Get latest version from GitHub API
                compose_version=$(wget -qO- https://api.github.com/repos/docker/compose/releases/latest | grep -oP '"tag_name": *"v\K[^"]+')
            fi
            
            wget -O ${docker_compose_path} "https://github.com/docker/compose/releases/download/v${compose_version}/docker-compose-linux-${target_compose_arch}"
            chmod +x ${docker_compose_path}
        fi
    fi
    
    # Install Docker Buildx if requested
    if [ "${INSTALL_DOCKER_BUILDX}" = "true" ]; then
        echo "(*) Installing Docker Buildx..."
        apk add --no-cache docker-cli-buildx
    fi
fi

# Setup a docker group in the event the docker socket's group is not root
if ! grep -qE '^docker:' /etc/group; then
    echo "(*) Creating missing docker group..."
    addgroup -S docker
fi

usermod -aG docker "${USERNAME}" 2>/dev/null || adduser "${USERNAME}" docker

# If init file already exists, exit
if [ -f "/usr/local/share/docker-init.sh" ]; then
    echo "docker-init already exists, skipping creation..."
    exit 0
fi
echo "docker-init doesn't exist, adding..."

# By default, make the source and target sockets the same
if [ "${SOURCE_SOCKET}" != "${TARGET_SOCKET}" ]; then
    touch "${SOURCE_SOCKET}"
    ln -s "${SOURCE_SOCKET}" "${TARGET_SOCKET}"
fi

# Add a stub if not adding non-root user access, user is root
if [ "${ENABLE_NONROOT_DOCKER}" = "false" ] || [ "${USERNAME}" = "root" ]; then
    printf '#!/usr/bin/env sh\nexec "$@"' > /usr/local/share/docker-init.sh
    chmod +x /usr/local/share/docker-init.sh
    exit 0
fi

DOCKER_GID="$(getent group docker | cut -d: -f3)"

# If enabling non-root access and specified user is found, setup socat and add script
chown -h "${USERNAME}":root "${TARGET_SOCKET}"
check_packages socat
tee /usr/local/share/docker-init.sh > /dev/null \
<< EOF
#!/usr/bin/env sh
#-------------------------------------------------------------------------------------------------------------
# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License. See https://go.microsoft.com/fwlink/?linkid=2090316 for license information.
#-------------------------------------------------------------------------------------------------------------

set -e

SOCAT_PATH_BASE=/tmp/vscr-docker-from-docker
SOCAT_LOG=\${SOCAT_PATH_BASE}.log
SOCAT_PID=\${SOCAT_PATH_BASE}.pid

# Wrapper function to only use sudo if not already root
sudoIf()
{
    if [ "\$(id -u)" -ne 0 ]; then
        sudo "\$@"
    else
        "\$@"
    fi
}

# Log messages
log()
{
    echo -e "[\$(date)] \$@" | sudoIf tee -a \${SOCAT_LOG} > /dev/null
}

echo -e "\n** \$(date) **" | sudoIf tee -a \${SOCAT_LOG} > /dev/null
log "Ensuring ${USERNAME} has access to ${SOURCE_SOCKET} via ${TARGET_SOCKET}"

# If enabled, try to update the docker group with the right GID. If the group is root,
# fall back on using socat to forward the docker socket to another unix socket so
# that we can set permissions on it without affecting the host.
if [ "${ENABLE_NONROOT_DOCKER}" = "true" ] && [ "${SOURCE_SOCKET}" != "${TARGET_SOCKET}" ] && [ "${USERNAME}" != "root" ] && [ "${USERNAME}" != "0" ]; then
    SOCKET_GID=\$(stat -c '%g' ${SOURCE_SOCKET})
    if [ "\${SOCKET_GID}" != "0" ] && [ "\${SOCKET_GID}" != "${DOCKER_GID}" ] && ! grep -E ".+:x:\${SOCKET_GID}" /etc/group; then
        sudoIf addgroup -g "\${SOCKET_GID}" docker-host 2>/dev/null || true
        sudoIf adduser "${USERNAME}" docker-host 2>/dev/null || true
    else
        # Enable proxy if not already running
        if [ ! -f "\${SOCAT_PID}" ] || ! ps -p \$(cat \${SOCAT_PID}) > /dev/null; then
            log "Enabling socket proxy."
            log "Proxying ${SOURCE_SOCKET} to ${TARGET_SOCKET} for vscode"
            sudoIf rm -rf ${TARGET_SOCKET}
            (sudoIf socat UNIX-LISTEN:${TARGET_SOCKET},fork,mode=660,user=${USERNAME},backlog=128 UNIX-CONNECT:${SOURCE_SOCKET} 2>&1 | sudoIf tee -a \${SOCAT_LOG} > /dev/null & echo "\$!" | sudoIf tee \${SOCAT_PID} > /dev/null)
        else
            log "Socket proxy already running."
        fi
    fi
    log "Success"
fi

# Execute whatever commands were passed in (if any). This allows us
# to set this script to ENTRYPOINT while still executing the default CMD.
set +e
exec "\$@"
EOF
chmod +x /usr/local/share/docker-init.sh
chown "${USERNAME}":root /usr/local/share/docker-init.sh

echo "Feature 'alpine-docker-outside-of-docker' installed successfully"
