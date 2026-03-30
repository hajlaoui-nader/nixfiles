# Overlays and Overrides

Overlays let you modify nixpkgs — add packages, replace packages, or change how existing packages are built — without forking the repository.

## What is an overlay?

An overlay is a function with two arguments:

```nix
final: prev: {
  # your modifications
}
```

- **`prev`** (also called `self` in old docs): The package set from the **previous layer** (before this overlay)
- **`final`** (also called `super` in old docs): The **final, fully-resolved** package set (after ALL overlays)

```nix
final: prev: {
  # Add a new package:
  myTool = final.writeShellScriptBin "mytool" ''echo hello'';

  # Modify an existing package:
  hello = prev.hello.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      echo "patched!" > $out/PATCHED
    '';
  });
}
```

## `final` vs `prev` — when to use which

This is the #1 source of confusion with overlays:

| Use `prev.package` when | Use `final.package` when |
|---|---|
| **Modifying** a package (need the original) | **Depending on** a package (want the latest version) |
| Calling `.overrideAttrs` | Using as `buildInputs` |
| The "old version" of what you're changing | Another package that might also be overlaid |

```nix
final: prev: {
  # CORRECT: override the previous version of hello
  hello = prev.hello.overrideAttrs (old: { ... });

  # CORRECT: use final.openssl so if someone else overlays openssl, we get that version
  myApp = prev.stdenv.mkDerivation {
    buildInputs = [ final.openssl ];
  };

  # WRONG: using final.hello would cause infinite recursion!
  # hello = final.hello.overrideAttrs (old: { ... });
}
```

**Rule**: Use `prev` for the thing you're modifying. Use `final` for everything else.

## Your direnv overlay

From `overlays/direnv-overlay.nix`:

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

This correctly uses `prev.direnv` (the unmodified direnv) and applies `.overrideAttrs` to patch its build.

## Applying overlays

### In a flake (your setup)

```nix
# hosts/mbp2023/system.nix:
nixpkgs.overlays = [ (import ../../overlays/direnv-overlay.nix) ];
```

### With `import <nixpkgs>`

```nix
pkgs = import <nixpkgs> {
  overlays = [
    (import ./overlays/direnv-overlay.nix)
    (final: prev: { myPkg = ...; })
  ];
};
```

## Stacking overlays

Overlays are applied in order. Each one sees the result of all previous overlays through `prev`:

```nix
overlays = [
  # Overlay 1: add a package
  (final: prev: {
    myLib = final.stdenv.mkDerivation { pname = "mylib"; ... };
  })

  # Overlay 2: use the package from overlay 1
  (final: prev: {
    myApp = final.stdenv.mkDerivation {
      buildInputs = [ final.myLib ];  # ← visible because overlay 1 added it
    };
  })
];
```

## `overrideAttrs` — deep dive

`overrideAttrs` takes a function `old: { ... }` where `old` is the previous attribute set:

```nix
pkgs.git.overrideAttrs (old: {
  # Add to existing patches:
  patches = (old.patches or []) ++ [ ./my-patch.patch ];

  # Extend a phase:
  postInstall = (old.postInstall or "") + ''
    echo "extra step"
  '';

  # Replace a value:
  version = "9.9.9";
})
```

Always use `(old.attr or default) +` to extend, not replace.

## `override` vs `overrideAttrs` vs overlays

| Mechanism | What it changes | When to use |
|---|---|---|
| `.override { }` | Function arguments (deps) | Swap a dependency |
| `.overrideAttrs (old: { })` | mkDerivation attrs | Patch, add phase, change version |
| Overlay | Entire package set | Add packages, apply patches globally |

## The fixed-point connection

Overlays work because nixpkgs is evaluated as a **fixed point** (covered in module 07). `final` is the fixed point — the package set after all overlays have been applied. This is why `final` can reference packages added by later overlays.

## Key takeaways

1. **Overlays are `final: prev: { ... }`** — prev is "before", final is "after all overlays"
2. **Use `prev` for what you're changing**, `final` for dependencies
3. **Overlays stack** — each sees the result of previous overlays
4. **`overrideAttrs`** modifies build attributes; `.override` modifies function inputs
5. **Always extend, don't replace**: `(old.patches or []) ++ [ ... ]`

## Exercises

See [exercises/e03-overlays.nix](exercises/e03-overlays.nix)
