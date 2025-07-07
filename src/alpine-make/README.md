
# GNU Make on Alpine (alpine-make)

Installs GNU Make build automation tool on Alpine Linux

## Example Usage

```json
"features": {
    "ghcr.io/sarigiannidis/features/alpine-make:1": {}
}
```



## make

### Feature Description

GNU Make is a build automation tool that controls the generation of executables and other non-source files from source code. This feature installs only GNU Make.

### What's Included

- `make` - GNU Make build automation tool only

### Use Cases

- Running Makefiles for simple projects
- Build automation without compilation
- Lightweight environments where only make is needed
- Base dependency for other build tools

### Related Features

- **`alpine-build-base`** - Complete build environment (includes make + gcc + build tools)
- **`alpine-node`** - Node.js development (often used with make for build scripts)
- **`alpine-python`** - Python development (may use make for automation)

### Usage Examples

#### Basic Usage
```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-make:latest": {}
    }
}
```

#### With Full Build Environment
For C/C++ development, use `alpine-build-base` which includes make + gcc + build tools:
```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-build-base:latest": {}
    }
}
```

#### With Other Development Tools
```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-bash:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-git:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-make:latest": {}
    }
}
```


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/sarigiannidis/features/blob/main/src/alpine-make/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
