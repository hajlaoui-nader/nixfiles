# Module Anatomy

Every NixOS, nix-darwin, and home-manager module follows the same structure. Understanding it deeply removes all mystery from config files.

## The module function signature

```nix
{ config, lib, pkgs, ... }:
{
  # module body
}
```

### The arguments

| Argument | What it is |
|----------|-----------|
| `config` | The final, merged configuration (all modules combined) |
| `lib` | nixpkgs library functions (types, mkOption, mkIf, etc.) |
| `pkgs` | The nixpkgs package set |
| `...` | Catches all other arguments (essential!) |

The `...` is critical — the module system passes many extra arguments (`options`, `modulesPath`, custom `specialArgs`). Without `...`, your module would throw "unexpected argument" errors.

### `specialArgs`

Extra arguments passed to all modules. In your `flake.nix`:

```nix
specialArgs = { inherit inputs; };
```

This makes `inputs` available in every module:

```nix
{ inputs, ... }:
{
  nix.registry.nixpkgs.flake = inputs.nixpkgs-unstable;
}
```

## Module forms

A module can be:

### 1. A function returning an attrset (most common)

```nix
{ config, lib, pkgs, ... }:
{
  imports = [ ... ];
  options = { ... };
  config = { ... };
}
```

### 2. A plain attrset (no function)

```nix
{
  programs.git.enable = true;
}
```

### 3. A path (imports the file)

```nix
imports = [
  ./git.nix              # a .nix file
  ../modules/home/common.nix  # another .nix file
  ../modules/home/zsh    # a directory (loads default.nix)
];
```

## `imports` — composition

`imports` is how modules compose. Each imported module is evaluated and merged:

```nix
# home/mbp2023.nix
{ pkgs, inputs, ... }:
{
  imports = [
    ../modules/home/home-manager.nix
    ../modules/home/common.nix
    ../modules/home/zsh
    ../modules/home/git.nix
    ../modules/home/tmux
    ../modules/home/ghostty
  ];

  # This module's own config:
  home.homeDirectory = "/Users/naderh";
  programs.git.settings.user.email = "hajlaoui.nader@gmail.com";
}
```

All imported modules are merged together. Order doesn't matter (thanks to the type system's merging rules).

## Implicit config

When a module has no `options` key, everything is implicitly `config`:

```nix
# These are equivalent:

# Implicit:
{ pkgs, ... }:
{
  programs.git.enable = true;
}

# Explicit:
{ pkgs, ... }:
{
  config = {
    programs.git.enable = true;
  };
}
```

You MUST use the explicit form when the module also declares `options`, to avoid ambiguity.

## `mkIf` — conditional config

```nix
{ config, lib, ... }:
{
  options.myFeature.enable = lib.mkEnableOption "my feature";

  config = lib.mkIf config.myFeature.enable {
    home.packages = [ /* ... */ ];
  };
}
```

`mkIf` doesn't short-circuit — the module system evaluates the structure but marks the values as conditional. This is why you can't use `if-then-else` instead:

```nix
# WRONG: This forces evaluation of config.myFeature.enable during module evaluation
config = if config.myFeature.enable then { ... } else { };

# RIGHT: mkIf defers the condition
config = lib.mkIf config.myFeature.enable { ... };
```

## Your modules dissected

Looking at `modules/home/git.nix`:

```nix
{ pkgs, ... }:           # Module function — takes pkgs, ignores the rest
{
  programs.git = {        # Implicit config — sets options declared by home-manager's git module
    enable = true;
    ignores = [ ... ];
    settings = { ... };
  };
  programs.delta = { ... };
}
```

This module doesn't declare any options — it only sets config values for options declared by home-manager's built-in `programs.git` module.

## Key takeaways

1. **`{ config, lib, pkgs, ... }:`** — the `...` absorbs extra args from the module system
2. **`config`** gives you the final merged state of ALL modules
3. **No `options` block** → everything is implicitly `config`
4. **`imports`** composes modules — order doesn't matter
5. **Use `mkIf`**, not `if-then-else`, for conditional config
6. **`specialArgs`** passes custom values (like `inputs`) to all modules

## Exercises

See [exercises/e02-module-anatomy.nix](exercises/e02-module-anatomy.nix)
