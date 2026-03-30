# The callPackage Pattern

`callPackage` is the most important pattern in nixpkgs. It's how packages declare their dependencies and how those dependencies get injected automatically.

## The problem

A package needs dependencies:

```nix
# ripgrep/default.nix
{ stdenv, fetchFromGitHub, rustPlatform }:

rustPlatform.buildRustPackage {
  pname = "ripgrep";
  # ...
}
```

This function needs `stdenv`, `fetchFromGitHub`, and `rustPlatform`. Someone has to call it with the right arguments.

## Manual approach (tedious)

```nix
ripgrep = import ./ripgrep {
  inherit stdenv fetchFromGitHub rustPlatform;
};
```

For 100,000+ packages, this is unmaintainable.

## `callPackage` — automatic injection

```nix
ripgrep = callPackage ./ripgrep { };
```

`callPackage` inspects the function's argument names using `builtins.functionArgs` and automatically fills them from the package set:

1. Look at the function: `{ stdenv, fetchFromGitHub, rustPlatform }:`
2. Find `stdenv` in `pkgs` → inject it
3. Find `fetchFromGitHub` in `pkgs` → inject it
4. Find `rustPlatform` in `pkgs` → inject it

The second argument `{ }` provides **overrides**:

```nix
# Use a different stdenv:
ripgrep = callPackage ./ripgrep {
  stdenv = pkgs.clangStdenv;
};
```

## `builtins.functionArgs` — the magic

```nix
nix-repl> f = { a, b, c ? 3 }: a + b + c
nix-repl> builtins.functionArgs f
{ a = false; b = false; c = true; }
```

Returns the argument names and whether they have defaults. `callPackage` uses this to know what to inject.

## Implementing callPackage from scratch

Here's a minimal `callPackage`:

```nix
callPackage = pkgs: fn: overrides:
  let
    f = if builtins.isFunction fn then fn else import fn;
    args = builtins.functionArgs f;
    # For each arg, use the override if provided, otherwise look in pkgs
    autoArgs = builtins.mapAttrs
      (name: _: overrides.${name} or pkgs.${name})
      args;
  in
    f autoArgs;
```

The real `callPackage` in nixpkgs is more sophisticated (handles `override`, `overrideAttrs`, etc.) but this captures the core idea.

## `.override` — the gift of callPackage

Every package created with `callPackage` gets a `.override` function for free:

```nix
nix-repl> pkgs.hello.override
«lambda»

# Change a dependency:
myHello = pkgs.hello.override {
  stdenv = pkgs.clangStdenv;
};
```

This re-calls the package function with your overrides merged in. It's how you customize packages without forking.

## `.overrideAttrs` — different from `.override`

```nix
# .override changes the INPUTS to the package function:
pkgs.hello.override { stdenv = ...; }

# .overrideAttrs changes the ATTRIBUTES of mkDerivation:
pkgs.hello.overrideAttrs (old: { pname = "hola"; })
```

| | `.override` | `.overrideAttrs` |
|---|---|---|
| Changes | Function arguments (deps) | mkDerivation attributes |
| Scope | Dependencies | Build config, phases, env |
| Example | Swap stdenv | Add a patch, change version |

## callPackage in your repo

Your packages don't use `callPackage` directly — they use the module system's `{ pkgs, ... }:` pattern, which is similar but handled by the module evaluator. However, if you ever add a custom package:

```nix
# In your overlay or flake outputs:
myPackage = pkgs.callPackage ./my-package.nix { };
```

## Key takeaways

1. **`callPackage` auto-injects dependencies** by inspecting function argument names
2. **`builtins.functionArgs`** is the magic that makes this work
3. **The second argument to `callPackage`** provides overrides
4. **`.override`** re-calls the package function with different inputs
5. **`.overrideAttrs`** modifies the mkDerivation attributes (different level)

## Exercises

See [exercises/e02-callpackage.nix](exercises/e02-callpackage.nix)
