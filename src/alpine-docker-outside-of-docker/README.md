
# Docker (docker-outside-of-docker for Alpine) (alpine-docker-outside-of-docker)

Re-use the host docker socket, adding the Docker CLI to an Alpine container. Feature invokes a script to enable using a forwarded Docker socket within a container to run Docker commands.

## Example Usage

```json
"features": {
    "ghcr.io/sarigiannidis/features/alpine-docker-outside-of-docker:1": {}
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



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sarigiannidis/features/blob/main/src/alpine-docker-outside-of-docker/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
