# nixos-rebuild / darwin-rebuild Internals

When you run `darwin-rebuild switch --flake .#mbp2023`, what actually happens? Understanding the pipeline from Nix expression to running system demystifies the "magic".

## The pipeline

```
flake.nix
   ↓  (evaluate)
darwinConfigurations.mbp2023.system
   ↓  (build)
/nix/store/...-darwin-system-...
   ↓  (activate)
Activation script runs
   ↓  (switch)
New profile linked, services restarted
```

## Step 1: Evaluate the configuration

```bash
# What darwin-rebuild evaluates:
nix eval .#darwinConfigurations.mbp2023.system
```

This triggers evaluation of:
1. Your `flake.nix` outputs function
2. `darwin.lib.darwinSystem { modules = [...]; }`
3. All imported modules (system.nix, home-manager, etc.)
4. The module system merges all options and config
5. The result is a massive attrset describing the entire system

## Step 2: The `toplevel` derivation

The evaluated configuration produces a **toplevel derivation** — a single store path containing everything needed to run the system:

```bash
# For NixOS:
nix eval .#nixosConfigurations.zeus.config.system.build.toplevel

# Inspect it:
nix build .#nixosConfigurations.zeus.config.system.build.toplevel
ls result/
```

The toplevel contains:
- `activate` — the activation script
- `sw/` — symlinks to all system packages
- `etc/` — generated configuration files
- `init` — the init script (NixOS)
- Systemd units, kernel, bootloader config (NixOS)

## Step 3: The activation script

The activation script performs all the side effects needed to make the new configuration live:

```bash
# Read the activation script:
cat /nix/store/...-darwin-system-.../activate
```

What it does:
- Creates/updates symlinks in `/etc/`
- Sets system defaults (`defaults write ...` on macOS)
- Configures PAM (TouchID sudo)
- Creates user accounts
- Sets up fonts
- Manages launch daemons/agents (macOS)
- Starts/stops/restarts services

### nix-darwin activation

On macOS, activation includes:
1. Linking system packages to `/run/current-system/sw/`
2. Writing `/etc/` files (shells, hosts, etc.)
3. Running `defaults write` for system preferences
4. Installing fonts
5. Managing launchd services
6. Updating the profile generation

### NixOS activation

On NixOS, activation includes:
1. Switching the systemd configuration
2. Updating the bootloader (GRUB/systemd-boot)
3. Creating `/etc/` symlinks
4. Running `systemctl daemon-reload`
5. Starting new services, stopping removed ones, restarting changed ones
6. Updating the profile generation

## Step 4: Profile switch

A **profile** is a symlink that tracks generations:

```
/nix/var/nix/profiles/system
   → /nix/var/nix/profiles/system-42-link
      → /nix/store/...-darwin-system-...
```

Each `switch` creates a new generation:

```
system-40-link → /nix/store/...-old-system
system-41-link → /nix/store/...-previous-system
system-42-link → /nix/store/...-current-system  ← current
```

This is how you can roll back:

```bash
# NixOS:
nixos-rebuild switch --rollback

# nix-darwin:
darwin-rebuild switch --rollback
```

Rolling back just switches the profile symlink to the previous generation and runs its activation script.

## Tracing darwin-rebuild

Your `scripts/darwin.sh` likely runs:

```bash
nix build .#darwinConfigurations.mbp2023.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#mbp2023
```

Breaking this down:
1. `nix build` evaluates and builds the system derivation
2. `darwin-rebuild switch` runs the activation script from the built result
3. The activation script applies all changes
4. A new profile generation is created

## Exploring in nix repl

```nix
nix repl
:lf .

# The full system configuration:
darwinConfigurations.mbp2023.config

# System packages:
darwinConfigurations.mbp2023.config.environment.systemPackages

# Home manager config (nested):
darwinConfigurations.mbp2023.config.home-manager.users.naderh.programs.git.enable

# The toplevel derivation:
darwinConfigurations.mbp2023.system
```

## Why rebuild can be slow

1. **Evaluation**: Nix evaluates all modules (fast, usually <10s)
2. **Diffing**: Determines what changed from current system (fast)
3. **Fetching**: Downloads new packages from binary cache (network-bound)
4. **Building**: Compiles anything not in the cache (can be slow)
5. **Activation**: Runs the activation script (fast)

Most time is spent in steps 3-4. Using a binary cache (like cachix or garnix) helps.

## Key takeaways

1. **`system.build.toplevel`** is the single derivation describing the entire system
2. **Activation scripts** perform side effects (symlinks, services, defaults)
3. **Profiles** track generations, enabling instant rollback
4. **darwin-rebuild/nixos-rebuild** = evaluate + build + activate + profile switch
5. **`nix repl` with `:lf .`** lets you explore your full configuration interactively

## Exercises

See [exercises/e03-rebuild-internals.sh](exercises/e03-rebuild-internals.sh)
