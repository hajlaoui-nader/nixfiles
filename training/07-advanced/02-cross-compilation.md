# Cross-Compilation

Cross-compilation in Nix is principled — the distinction between build-time and run-time tools is baked into the package system.

## The three platforms

```
Build    →    Host    →    Target
machine        machine      machine
```

| Platform | What runs here | Example |
|----------|---------------|---------|
| **Build** | The build tools (compiler, make, cmake) | Your Mac (aarch64-darwin) |
| **Host** | The built software itself | Raspberry Pi (aarch64-linux) |
| **Target** | What the built software generates code for | (only relevant for compilers) |

For most packages, **build** and **host** are the only ones that matter. **Target** only matters for compiler packages (e.g., building a cross-compiler).

## Native vs cross builds

```
Native build:     build == host     (building git on Mac, to run on Mac)
Cross build:      build != host     (building git on Mac, to run on Raspberry Pi)
```

## `nativeBuildInputs` vs `buildInputs` — now it matters

In module 02 we said:
- `nativeBuildInputs` = build tools
- `buildInputs` = runtime libraries

For native builds, the distinction is cosmetic. For cross builds, it's critical:

```nix
pkgs.stdenv.mkDerivation {
  pname = "myapp";

  # Runs on the BUILD machine during compilation:
  nativeBuildInputs = [
    pkgs.cmake        # build tool — must run on Mac
    pkgs.pkg-config   # build tool — must run on Mac
  ];

  # Linked into the final binary, runs on the HOST machine:
  buildInputs = [
    pkgs.openssl      # library — must be compiled for Raspberry Pi
    pkgs.zlib         # library — must be compiled for Raspberry Pi
  ];
}
```

If you put `cmake` in `buildInputs` during cross-compilation, Nix would try to build cmake for the target architecture — which can't run on your build machine.

## `pkgsCross` — cross-compiling with nixpkgs

nixpkgs provides pre-configured cross-compilation package sets:

```nix
# In nix repl:
pkgs = import <nixpkgs> {}

# Cross-compile hello for aarch64-linux (from any build machine):
pkgs.pkgsCross.aarch64-multiplatform.hello

# For Raspberry Pi:
pkgs.pkgsCross.raspberryPi.hello

# For RISC-V:
pkgs.pkgsCross.riscv64.hello

# For Windows (MinGW):
pkgs.pkgsCross.mingwW64.hello

# Static linking:
pkgs.pkgsStatic.hello
```

## How it works under the hood

When you use `pkgsCross`, nixpkgs rebuilds the entire package set with:
- `buildPlatform` = your current system
- `hostPlatform` = the target architecture

This changes how `nativeBuildInputs` and `buildInputs` are resolved:

```nix
# Native build:
nativeBuildInputs → packages for x86_64-linux
buildInputs       → packages for x86_64-linux  (same!)

# Cross build (to aarch64-linux):
nativeBuildInputs → packages for x86_64-linux   (build machine)
buildInputs       → packages for aarch64-linux  (target machine)
```

## Splicing

Nix uses a mechanism called **splicing** to automatically pick the right package variant:

```nix
# In a cross-compilation context:
# pkgs.cmake          → the build-machine cmake (for nativeBuildInputs)
# pkgs.cmake.__spliced.hostTarget  → cmake for the target (rare, but exists)
```

You usually don't need to think about splicing — the build system handles it. But knowing it exists helps debug cross-compilation issues.

## Inspecting a cross derivation

```bash
# Show the derivation for a cross-compiled hello:
nix derivation show 'nixpkgs#pkgsCross.aarch64-multiplatform.hello'

# Compare with native:
nix derivation show 'nixpkgs#hello'
```

Look at:
- `system`: Should match your build machine
- `env.buildInputs`: Should reference aarch64-linux store paths
- `env.nativeBuildInputs`: Should reference your build machine's store paths

## Practical: cross-compiling for your Pi

If you had a `homepi` configuration, you could cross-compile from your Mac:

```bash
# From your Mac:
nix build .#homeConfigurations.homepi.activationPackage \
  --system aarch64-linux
```

Or in `flake.nix`:

```nix
packages.aarch64-darwin.homepi-activation =
  self.homeConfigurations.homepi.activationPackage;
```

## Key takeaways

1. **Build/host/target** — three platforms, usually only build and host matter
2. **`nativeBuildInputs`** runs on build machine; **`buildInputs`** links for host machine
3. **`pkgsCross.*`** provides pre-configured cross package sets
4. **Splicing** automatically selects the right package variant
5. Getting `nativeBuildInputs` vs `buildInputs` right is critical for cross builds

## Exercises

See [exercises/e02-cross.sh](exercises/e02-cross.sh)
