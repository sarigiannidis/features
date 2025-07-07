# Build-base on Alpine

Install build-base package with essential build tools on Alpine Linux containers.

The `build-base` package is Alpine Linux's meta-package that provides a complete build environment including GCC, GNU Make, and essential development libraries. This feature automatically includes the `alpine-make` feature as a dependency.

## Example Usage

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-build-base:latest": {}
    }
}
```

### With Development Tools

```json
{
    "features": {
        "ghcr.io/sarigiannidis/features/alpine-bash:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-git:latest": {},
        "ghcr.io/sarigiannidis/features/alpine-build-base:latest": {}
    }
}
```

### For C/C++ Development

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

## What's Included

The `build-base` package includes these essential build tools:

- `make` - GNU Make build automation tool (via alpine-make dependency)
- `gcc` - GNU Compiler Collection (C compiler)
- `g++` - GNU C++ Compiler
- `binutils` - Binary utilities (assembler, linker, ar, objdump, etc.)
- `libc-dev` - C library development files and headers
- `file` - File type identification utility
- `fortify-headers` - Security-enhanced system headers
- `patch` - Apply patches to source files

## Dependencies

This feature automatically installs:
- **`alpine-make`** - GNU Make (required dependency)

## Use Cases

### C/C++ Development
```bash
# Compile a simple C program
gcc hello.c -o hello
./hello
```

### Building from Source
```bash
# Typical autotools build process
./configure
make
make install
```

### Cross-platform Development
```bash
# Build with specific flags
gcc -static -o myapp main.c
```

### Kernel Module Development
```bash
# Build kernel modules (requires additional kernel headers)
make -C /lib/modules/$(uname -r)/build M=$(pwd) modules
```

## When to Use

- **Use `alpine-build-base`** when you need to compile C/C++ code
- **Use `alpine-make`** only when you just need make for automation scripts
- **Perfect for** Docker images that build software from source
- **Essential for** CI/CD pipelines that compile native code

## Supported Platforms

- linux/amd64
- linux/arm64

---

_Note: This Feature is published to ghcr.io/sarigiannidis/features._
