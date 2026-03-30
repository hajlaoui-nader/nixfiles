# Build Phases

`stdenv.mkDerivation` runs your build through a sequence of **phases**. Understanding this sequence lets you hook into exactly the right point.

## The phase sequence

```
unpackPhase
  ↓
patchPhase
  ↓
configurePhase
  ↓
buildPhase
  ↓
checkPhase        (only if doCheck = true)
  ↓
installPhase
  ↓
fixupPhase
  ↓
installCheckPhase (only if doInstallCheck = true)
```

Each phase has:
- A **pre** hook: `preUnpack`, `preBuild`, etc.
- The **main** phase: `unpackPhase`, `buildPhase`, etc.
- A **post** hook: `postUnpack`, `postBuild`, etc.

## Default phase behavior

### unpackPhase
Extracts `$src` (tar, zip, etc.) and `cd`s into the extracted directory.

Skip with: `dontUnpack = true;` (for single-file sources)

### patchPhase
Applies patches from the `patches` list:

```nix
patches = [
  ./fix-build.patch
  (fetchpatch {
    url = "https://...";
    hash = "sha256-...";
  })
];
```

### configurePhase
Runs `./configure --prefix=$out` if a configure script exists.

Override: `configureFlags = [ "--enable-feature" ];`
Skip with: `dontConfigure = true;`

### buildPhase
Runs `make` by default.

Override: `buildPhase = "cargo build --release";`
Or use: `makeFlags = [ "CC=gcc" "PREFIX=$(out)" ];`

### installPhase
Runs `make install` by default.

Override for custom install logic:
```nix
installPhase = ''
  mkdir -p $out/bin
  cp target/release/myapp $out/bin/
'';
```

### fixupPhase
Automatic post-processing:
- Strips debug symbols from binaries
- Patches ELF binaries to use Nix store paths for dynamic libraries
- Compresses man pages
- Runs `patchShebangs` on scripts (rewrites `#!/usr/bin/env bash` → `/nix/store/...-bash/bin/bash`)

This phase is why Nix binaries work without system-level dependencies.

## Overriding individual phases

```nix
pkgs.stdenv.mkDerivation {
  pname = "example";
  version = "1.0";
  src = ./.;

  # Add a command before the build
  preBuild = ''
    echo "About to build..."
    export EXTRA_FLAGS="-O2"
  '';

  # Add a command after install
  postInstall = ''
    mkdir -p $out/share
    cp README.md $out/share/
  '';
}
```

## `substituteInPlace` — patching without patch files

`substituteInPlace` is a shell function provided by stdenv for quick text replacements:

```nix
postPatch = ''
  substituteInPlace Makefile \
    --replace-fail "gcc" "${pkgs.gcc}/bin/gcc" \
    --replace-fail "/usr/local" "$out"
'';
```

Your `overlays/direnv-overlay.nix` uses exactly this pattern:

```nix
final: prev: {
  direnv = prev.direnv.overrideAttrs (old: {
    postPatch = (old.postPatch or "") + ''
      substituteInPlace GNUmakefile \
        --replace-fail "GO_LDFLAGS += -linkmode=external" ""
    '';
  });
}
```

Notice how it appends to `old.postPatch` with `(old.postPatch or "") +` — this preserves any existing patch commands.

## `overrideAttrs` — modify a package's derivation

```nix
pkgs.hello.overrideAttrs (old: {
  postInstall = (old.postInstall or "") + ''
    echo "Custom step"
  '';
})
```

`old` is the previous attrset, so you can extend rather than replace.

## Debugging phases

Echo in each phase to understand the sequence:

```nix
pkgs.stdenv.mkDerivation {
  pname = "debug-phases";
  version = "0.1";
  src = ./.;

  postUnpack   = ''echo "── postUnpack ──"'';
  postPatch    = ''echo "── postPatch ──"'';
  preConfigure = ''echo "── preConfigure ──"'';
  preBuild     = ''echo "── preBuild ──"'';
  preInstall   = ''echo "── preInstall ──"'';
  postInstall  = ''echo "── postInstall ──"'';
  postFixup    = ''echo "── postFixup ──"'';

  buildPhase = "true";  # skip actual build
  installPhase = "mkdir -p $out";
}
```

Build with `nix build -L` to see the output.

## Key takeaways

1. **Phases run in a fixed order**: unpack → patch → configure → build → install → fixup
2. **Each phase has pre/post hooks** for surgical modifications
3. **`substituteInPlace`** lets you patch files without creating `.patch` files
4. **`overrideAttrs`** lets you modify any phase of an existing package
5. **fixupPhase** is magic — it patches binaries, rewrites shebangs, strips symbols
6. **Append, don't replace**: Use `(old.postPatch or "") +` to extend phases safely

## Exercises

See [exercises/e04-phases.nix](exercises/e04-phases.nix)
