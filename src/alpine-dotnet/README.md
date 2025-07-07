
# dotnet on alpine (alpine-dotnet)

Installs .NET SDK and runtime on Alpine Linux (requires bash for Microsoft's official installer)

## Example Usage

```json
"features": {
    "ghcr.io/sarigiannidis/features/alpine-dotnet:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| architecture | Architecture of the .NET binaries to install. | string | <auto> |
| channel | Specifies the source channel for the installation. | string | LTS |
| quality | Specifies the quality of the .NET SDK to install. | string | GA |
| runtime | Installs just the shared runtime, not the entire SDK. | string | dotnet |
| version | Version of the .NET SDK to install. | string | latest |

## dotnet

### Why bash is required

This feature depends on `alpine-bash` because it uses the `dotnet-install.sh` script from Microsoft, which requires bash to run.

### Links

* <https://dotnet.microsoft.com/en-us/download/dotnet/scripts>
* <https://learn.microsoft.com/en-gb/dotnet/core/tools/dotnet-install-script>
* <https://github.com/dotnet/core/blob/main/release-notes/9.0/install.md>


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sarigiannidis/features/blob/main/src/alpine-dotnet/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
