# Writing a Module

Now that you understand options and config separately, let's combine them to write reusable modules that other modules can configure.

## A complete module

```nix
{ config, lib, pkgs, ... }:

let
  cfg = config.services.myWebApp;
in
{
  options.services.myWebApp = {
    enable = lib.mkEnableOption "my web application";

    port = lib.mkOption {
      type = lib.types.port;
      default = 8080;
      description = "Port the web app listens on.";
    };

    dataDir = lib.mkOption {
      type = lib.types.path;
      default = "/var/lib/mywebapp";
      description = "Directory for application data.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.nginx ];  # or whatever runtime deps

    # Create a wrapper script
    home.file.".local/bin/start-mywebapp" = {
      executable = true;
      text = ''
        #!/usr/bin/env bash
        echo "Starting web app on port ${toString cfg.port}"
        echo "Data directory: ${cfg.dataDir}"
      '';
    };
  };
}
```

### The `cfg` pattern

```nix
let cfg = config.services.myWebApp; in
```

This is a convention — `cfg` is a short alias for the module's own config section. It avoids writing `config.services.myWebApp.port` everywhere.

## Inter-module dependencies

Modules can read each other's config:

```nix
# Module A: declares a port
{ lib, ... }:
{
  options.services.backend.port = lib.mkOption {
    type = lib.types.port;
    default = 3000;
  };
}
```

```nix
# Module B: uses Module A's port
{ config, lib, ... }:
{
  config = lib.mkIf config.services.frontend.enable {
    # Reference Module A's config value:
    services.frontend.backendUrl = "http://localhost:${toString config.services.backend.port}";
  };
}
```

This works because:
1. All modules are evaluated together
2. `config` is the **final merged** state
3. Laziness allows circular references (A reads B's config, B reads A's config)

## Converting existing code to a module

Take your `modules/home/git.nix`. Currently it hardcodes settings:

```nix
{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings.user.name = "Nader Hajlaoui";
    # ...
  };
}
```

As a proper module with options:

```nix
{ config, lib, pkgs, ... }:

let cfg = config.my.git;
in {
  options.my.git = {
    enable = lib.mkEnableOption "Git configuration";

    userName = lib.mkOption {
      type = lib.types.str;
      default = "Nader Hajlaoui";
      description = "Git user name.";
    };

    userEmail = lib.mkOption {
      type = lib.types.str;
      description = "Git user email.";
      # No default — force each machine to set this
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings.user.name = cfg.userName;
      settings.user.email = cfg.userEmail;
      # ... rest of git config
    };
  };
}
```

Now each machine config says:

```nix
my.git = {
  enable = true;
  userEmail = "hajlaoui.nader@gmail.com";
};
```

## When to write a module vs when not to

**Write a module when**:
- Multiple machines need different values for the same thing
- You want `enable`/`disable` semantics
- Config has inter-dependencies with other modules

**Don't write a module when**:
- The config is simple and the same everywhere
- You're just importing shared settings (a plain config is fine)

Your current approach in nixfiles — shared config modules without custom options — is perfectly valid for your use case.

## Key takeaways

1. **`let cfg = config.my.thing;`** is the standard pattern for module self-reference
2. **`mkIf cfg.enable`** gates all config on the enable option
3. **Modules read each other's config** via the shared `config` argument
4. **Not everything needs to be a module** — plain shared configs are fine for simple cases
5. Modules are most valuable when **different machines need different values**

## Exercises

See [exercises/e03-write-module.nix](exercises/e03-write-module.nix)
