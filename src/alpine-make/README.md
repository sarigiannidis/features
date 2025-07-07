# GNU Make on Alpine

Install GNU Make build tool and optional build essentials on Alpine Linux containers.

GNU Make is a build automation tool that controls the generation of executables and other non-source files from source code. This feature installs GNU Make and optionally includes build-base package with essential build tools like GCC, libc-dev, and other common development dependencies.

## Example Usage

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-make:latest": {
            "includeBuildBase": true
        }
    }
}
```

### Minimal Installation (Make only)

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-make:latest": {
            "includeBuildBase": false
        }
    }
}
```

### With Other Development Tools

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-bash:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-git:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-make:latest": {
            "includeBuildBase": true
        }
    }
}
```

## Options

| Option | Description | Default |
|--------|-------------|---------|
| includeBuildBase | Include build-base package with GCC, libc-dev, and other build tools | true |

## What's Included

### Always Installed
- `make` - GNU Make build tool

### When includeBuildBase=true (default)
- `build-base` package which includes:
  - `gcc` - GNU Compiler Collection
  - `libc-dev` - C library development files
  - `binutils` - Binary utilities
  - `make` - GNU Make (already included above)

## Use Cases

- Building C/C++ projects
- Automating build processes
- Running Makefiles for various projects
- Development environments requiring compilation tools

## Supported Platforms

- linux/amd64
- linux/arm64

---

_Note: This Feature is published to ghcr.io/sarigiannidis/features._
