# Docker (docker-outside-of-docker for Alpine)

Re-use the host docker socket, adding the Docker CLI to an Alpine Linux container. Feature invokes a script to enable using a forwarded Docker socket within a container to run Docker commands.

## Example Usage

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-docker-outside-of-docker:latest": {}
    }
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| version | Select or enter a Docker CLI version. (Availability can vary by OS version.) | string | latest |
| dockerDashComposeVersion | Compose version to use for docker-compose (v1 or v2 or none) | string | v2 |
| installDockerBuildx | Install Docker Buildx | boolean | true |

## Customizations

### VS Code Extensions

- `ms-azuretools.vscode-containers`

## Limitations

- As the name implies, the Feature is expected to work when the host is running Docker (or the OSS Moby container engine it is built on). It may be possible to get running in other container engines, but it has not been tested with them.
- The host and the container must be running on the same chip architecture. You will not be able to use it with an emulated x86 image with Docker Desktop on an Apple Silicon Mac, for example.
- This approach does not currently enable bind mounting the workspace folder by default, and cannot support folders outside of the workspace folder. Consider whether the [Docker-in-Docker Feature](../docker-in-docker) would better meet your needs given it does not have this limitation.

## Supporting bind mounts from the workspace folder

A common question that comes up is how you can use `bind` mounts from the Docker CLI from within the a dev container using this Feature (e.g. via `-v`). The only way to work around this is to use the **host**'s folder paths instead of the container's paths. There are 2 ways to do this

### 1. Use the `${localWorkspaceFolder}` as environment variable in your code

1. Add the following to `devcontainer.json`:

```json
"remoteEnv": { "LOCAL_WORKSPACE_FOLDER": "${localWorkspaceFolder}" }
```

2. Usage with Docker commands

```bash
docker run -it --rm -v ${LOCAL_WORKSPACE_FOLDER}:/workspace alpine sh
```

3. Usage with Docker-compose

```yaml
version: "3.9"

services:
  alpine:
    image: alpine
    volumes:
      - ${LOCAL_WORKSPACE_FOLDER:-./}:/workspace
```

- The defaults value `./` is added so that the `docker-compose.yaml` file can work when it is run outside of the container

### 2. Change the workspace to `${localWorkspaceFolder}`

- This is useful if we don't want to edit the `docker-compose.yaml` file

1. Add the following to `devcontainer.json`

```json
"workspaceFolder": "${localWorkspaceFolder}",
"workspaceMount": "source=${localWorkspaceFolder},target=${localWorkspaceFolder},type=bind"
```

2. Rebuild the container.
3. When the container first started with this settings, select the Workspace with the absolute path to the working directory inside the container
4. Docker commands with bind mount should work as they did outside of the devcontainer

> **Note:** There is no `${localWorkspaceFolder}` when using the **Clone Repository in Container Volume** command in the VS Code Dev Containers extension ([info](https://github.com/microsoft/vscode-remote-release/issues/6160#issuecomment-1014701007)).

## OS Support

This Feature should work on recent versions of Alpine Linux with the `apk` package manager installed.

## Supported Platforms

- linux/amd64
- linux/arm64

---

_Note: This Feature is published to ghcr.io/sarigiannidis/features._
