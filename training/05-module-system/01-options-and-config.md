# Options and Config

The NixOS/nix-darwin/home-manager module system is a typed configuration framework. It separates **option declarations** (the schema) from **config values** (the data).

## The two halves

Every module contributes to two things:
1. **`options`**: Declares what CAN be configured (schema, types, defaults, docs)
2. **`config`**: Sets actual values for declared options

```nix
{ lib, config, ... }:

{
  options.services.myService = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to enable myService";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port to listen on";
    };
  };

  config = lib.mkIf config.services.myService.enable {
    # Only applied when enable = true
    environment.systemPackages = [ /* ... */ ];
  };
}
```

## `mkOption`

`mkOption` declares a typed configuration slot:

```nix
lib.mkOption {
  type = lib.types.str;        # the type (required for proper merging)
  default = "hello";            # default value (optional)
  example = "world";            # example for docs (optional)
  description = "A greeting";   # for documentation (optional)
}
```

## `mkEnableOption`

Shorthand for the common `enable` boolean:

```nix
# These are equivalent:
options.services.foo.enable = lib.mkEnableOption "foo service";

options.services.foo.enable = lib.mkOption {
  type = lib.types.bool;
  default = false;
  description = "Whether to enable foo service.";
};
```

## Setting option values

Options are set in `config` (or at the top level if there's no `options` block):

```nix
# In a module with no options block, everything is implicitly config:
{ pkgs, ... }:
{
  programs.git.enable = true;        # sets config.programs.git.enable
  home.packages = [ pkgs.ripgrep ];  # sets config.home.packages
}
```

This is why your `home/mbp2023.nix` doesn't have an explicit `config = { ... }` block — everything is implicitly config.

## `mkDefault` and `mkForce`

When multiple modules set the same option, the module system must decide which value wins.

### Priority system

```nix
# Normal priority (1000):
programs.git.enable = true;

# Low priority (1500) — can be overridden:
programs.git.enable = lib.mkDefault true;

# High priority (50) — overrides everything:
programs.git.enable = lib.mkForce false;
```

Lower number = higher priority. The default priority is 1000.

### When to use each

- **`mkDefault`**: In shared/common modules, so per-machine configs can override
- **Normal assignment**: In per-machine configs
- **`mkForce`**: When you absolutely need to override, regardless of other modules

```nix
# modules/home/common.nix might set:
programs.git.enable = lib.mkDefault true;

# home/mbp2023.nix can override:
programs.git.enable = false;  # wins over mkDefault
```

## `mkMerge`

Combine multiple config blocks conditionally:

```nix
{ config, lib, ... }:
{
  config = lib.mkMerge [
    {
      # Always applied:
      environment.systemPackages = [ pkgs.vim ];
    }

    (lib.mkIf config.services.nginx.enable {
      # Only when nginx is enabled:
      networking.firewall.allowedTCPPorts = [ 80 443 ];
    })
  ];
}
```

## How merging works

The module system deeply merges config values:

```nix
# Module A:
home.packages = [ pkgs.git ];

# Module B:
home.packages = [ pkgs.ripgrep ];

# Result (lists concatenate):
home.packages = [ pkgs.git pkgs.ripgrep ];
```

This is **deep merging** — unlike `//` which is shallow. Different types merge differently:
- **Lists**: Concatenated
- **Attribute sets**: Recursively merged
- **Scalars** (bool, str, int): Error if conflicting (use priority to resolve)

## `lib.evalModules`

You can use the module system standalone (outside NixOS/home-manager):

```nix
let
  result = lib.evalModules {
    modules = [
      { options.name = lib.mkOption { type = lib.types.str; }; }
      { config.name = "hello"; }
    ];
  };
in
  result.config.name  # "hello"
```

This is great for understanding and experimenting with the module system in isolation.

## Key takeaways

1. **`options`** declares the schema; **`config`** sets values
2. **`mkDefault`** sets low-priority values; **`mkForce`** overrides everything
3. **Lists concatenate**, attrsets deep-merge, scalars conflict
4. **`mkIf`** conditionally applies config blocks
5. **`lib.evalModules`** lets you use the module system standalone

## Exercises

See [exercises/e01-options-config.nix](exercises/e01-options-config.nix)
