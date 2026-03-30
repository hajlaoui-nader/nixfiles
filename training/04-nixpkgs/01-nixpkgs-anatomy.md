# nixpkgs Anatomy

nixpkgs is the largest package repository in the world — 100,000+ packages in a single Git repository. Understanding its structure lets you navigate it, contribute to it, and debug issues.

## The big picture

```
nixpkgs/
├── default.nix          # Entry point for `import <nixpkgs> {}`
├── pkgs/
│   ├── top-level/
│   │   └── all-packages.nix   # The master list — maps names to packages
│   ├── by-name/               # New convention: one dir per package
│   │   ├── he/hello/
│   │   │   └── package.nix
│   │   └── ri/ripgrep/
│   │       └── package.nix
│   ├── build-support/         # mkDerivation, fetchurl, etc.
│   ├── development/           # Compilers, interpreters, libraries
│   ├── applications/          # End-user applications
│   └── ...
├── lib/                       # Pure Nix utility functions
│   ├── default.nix
│   ├── attrsets.nix
│   ├── lists.nix
│   ├── strings.nix
│   └── ...
└── nixos/                     # NixOS modules
    └── modules/
```

## `all-packages.nix` — the registry

`pkgs/top-level/all-packages.nix` is where package names are mapped to their definitions:

```nix
# Simplified from all-packages.nix:
{
  hello = callPackage ../applications/misc/hello { };
  ripgrep = callPackage ../applications/search/ripgrep { };
  git = callPackage ../applications/version-management/git { };
  # ... 100,000+ more entries
}
```

Every `pkgs.something` resolves through this file.

## `pkgs/by-name/` — the new convention

Newer packages use the `by-name` convention, which auto-discovers packages without needing an entry in `all-packages.nix`:

```
pkgs/by-name/he/hello/package.nix
              ^^
              first two letters of the package name
```

The file is a function that `callPackage` can call:

```nix
# pkgs/by-name/he/hello/package.nix
{ stdenv, fetchurl }:

stdenv.mkDerivation {
  pname = "hello";
  version = "2.12.1";
  src = fetchurl { ... };
}
```

## `lib` — utility functions

`lib` is a collection of pure Nix functions. It's NOT a package — it produces no derivations. Key modules:

```nix
lib.attrsets   # mapAttrs, filterAttrs, recursiveUpdate, ...
lib.lists      # map, filter, flatten, unique, ...
lib.strings    # concatStrings, optionalString, hasPrefix, ...
lib.trivial    # id, const, flip, pipe, ...
lib.options    # mkOption, mkEnableOption, ... (module system)
lib.modules    # evalModules, mkIf, mkMerge, ...
lib.types      # types.bool, types.str, types.listOf, ...
```

Access in the repl:

```nix
nix-repl> :lf nixpkgs
nix-repl> lib = inputs.nixpkgs-unstable.lib
nix-repl> lib.strings.concatStringsSep ", " [ "a" "b" "c" ]
"a, b, c"
```

## Exploring nixpkgs in the repl

```nix
# Load nixpkgs:
nix repl
> pkgs = import <nixpkgs> {}

# Find a package's source location:
> pkgs.ripgrep.meta.position
"/.../pkgs/applications/search/ripgrep/default.nix:49"

# See a package's inputs:
> pkgs.ripgrep.buildInputs
[ ... ]

# Check a package's meta:
> pkgs.ripgrep.meta.description
"A fast line-oriented regex search tool..."

# List all attributes (careful — this is huge):
> builtins.length (builtins.attrNames pkgs)
70000+
```

## How `import <nixpkgs> {}` works

```nix
import <nixpkgs> {}
```

This calls `nixpkgs/default.nix` with `{}` as the argument. The function accepts a config attrset:

```nix
import <nixpkgs> {
  config.allowUnfree = true;           # allow proprietary packages
  overlays = [ myOverlay ];            # apply custom overlays
  system = "x86_64-linux";            # cross-compile target
}
```

Your `hosts/mbp2023/system.nix` does this via nix-darwin's `nixpkgs.config`:

```nix
nixpkgs.config.allowUnfree = true;
nixpkgs.config.allowBroken = true;
```

## Key takeaways

1. **`all-packages.nix`** is the master registry mapping names to packages
2. **`pkgs/by-name/`** is the new auto-discovered convention
3. **`lib`** is pure utility functions, not packages
4. **`meta.position`** tells you where a package is defined
5. **`import <nixpkgs> { config = ...; }`** configures the package set

## Exercises

See [exercises/e01-explore-nixpkgs.sh](exercises/e01-explore-nixpkgs.sh)
