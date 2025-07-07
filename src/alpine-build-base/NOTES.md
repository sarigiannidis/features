## build-base

### Feature Description

The `build-base` package is Alpine Linux's meta-package that provides a complete build environment including GCC, GNU Make, and essential development libraries.

### What's Included

The `build-base` package includes these essential build tools:

- `make` - GNU Make build automation tool (via alpine-make dependency)
- `gcc` - GNU Compiler Collection (C compiler)
- `g++` - GNU C++ Compiler
- `binutils` - Binary utilities (assembler, linker, ar, objdump, etc.)
- `libc-dev` - C library development files and headers
- `file` - File type identification utility
- `fortify-headers` - Security-enhanced system headers
- `patch` - Apply patches to source files

### Usage Examples

#### Basic Usage

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-build-base:latest": {}
    }
}
```

#### With Development Tools

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-bash:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-git:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-build-base:latest": {}
    }
}
```

#### For C/C++ Development

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-bash:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-git:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-jq:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-build-base:latest": {}
    }
}
```
