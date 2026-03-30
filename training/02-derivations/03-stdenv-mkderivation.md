# stdenv.mkDerivation

Nobody uses `builtins.derivation` directly for real packages. Instead, nixpkgs provides `stdenv.mkDerivation` — a powerful wrapper that gives you a compiler toolchain, standard build phases, and common utilities.

## What stdenv provides

`stdenv` (standard environment) is a derivation itself that bundles:
- A C compiler (gcc on Linux, clang on macOS)
- GNU coreutils (`cp`, `mkdir`, `cat`, etc.)
- GNU make, patch, tar, gzip
- A standard builder script (`setup.sh`)

When you use `mkDerivation`, your build script runs in an environment where all these tools are available.

## Basic mkDerivation

```nix
{ pkgs }:

pkgs.stdenv.mkDerivation {
  pname = "hello-custom";
  version = "1.0";

  src = ./src;  # directory containing source code

  buildPhase = ''
    gcc -o hello hello.c
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp hello $out/bin/
  '';
}
```

### `pname` + `version` vs `name`

You can use either:
- `name = "hello-1.0";` — single string
- `pname = "hello"; version = "1.0";` — separate (preferred, enables version queries)

## buildInputs vs nativeBuildInputs

This distinction matters for cross-compilation, but understanding it now prevents future confusion:

| Attribute | Runs on | Contains |
|-----------|---------|----------|
| `nativeBuildInputs` | Build machine | Build tools: compilers, code generators, cmake, pkg-config |
| `buildInputs` | Target machine | Libraries the output links against at runtime |

For native builds (not cross-compiling), both work. But best practice:

```nix
pkgs.stdenv.mkDerivation {
  pname = "myapp";
  version = "1.0";
  src = ./.;

  nativeBuildInputs = [ pkgs.cmake pkgs.pkg-config ];  # build tools
  buildInputs = [ pkgs.openssl pkgs.zlib ];              # libraries
}
```

**Rule of thumb**: If you run it during the build, it's `nativeBuildInputs`. If you link against it, it's `buildInputs`.

## Source fetching

Most packages don't use local source. Instead they fetch from the internet:

```nix
pkgs.stdenv.mkDerivation {
  pname = "hello";
  version = "2.12.1";

  src = pkgs.fetchurl {
    url = "https://ftp.gnu.org/gnu/hello/hello-2.12.1.tar.gz";
    hash = "sha256-jZkUKv2SV28wsM18tCqNxoCZmLxdYH2Idh9RLibH2yA=";
  };

  # No buildPhase/installPhase needed — stdenv's defaults handle
  # standard autoconf packages (./configure && make && make install)
}
```

`fetchurl` is a **fixed-output derivation** — it has network access but Nix verifies the hash of the result.

## The default builder

If you don't specify `buildPhase` or `installPhase`, stdenv runs its defaults:
1. `./configure --prefix=$out` (if a `configure` script exists)
2. `make`
3. `make install`

This works for most GNU autotools packages out of the box.

## Wrapper scripts

A common pattern — package a shell script:

```nix
pkgs.stdenv.mkDerivation {
  pname = "my-script";
  version = "1.0";
  src = ./my-script.sh;

  dontUnpack = true;  # src is a single file, not a tarball

  installPhase = ''
    mkdir -p $out/bin
    cp $src $out/bin/my-script
    chmod +x $out/bin/my-script
  '';
}
```

Or even simpler with `writeShellScriptBin` (which uses `mkDerivation` under the hood):

```nix
pkgs.writeShellScriptBin "my-script" ''
  echo "Hello from Nix!"
''
```

## Key takeaways

1. **`mkDerivation` wraps `builtins.derivation`** with a standard environment
2. **stdenv gives you** a compiler, coreutils, make, and standard build phases
3. **`nativeBuildInputs`** = build tools; **`buildInputs`** = runtime libraries
4. **Default phases** handle standard autotools projects automatically
5. **`fetchurl`** is a fixed-output derivation with hash verification

## Exercises

See [exercises/e03-mkderivation.nix](exercises/e03-mkderivation.nix)
