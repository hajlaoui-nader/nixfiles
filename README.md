# nixfiles

Nix flakes configuration managing system and home environments across multiple machines.

| Host | Platform | Type |
|------|----------|------|
| `mbp2023` | macOS (Apple Silicon) | nix-darwin + home-manager |
| `zeus` | NixOS (x86_64) | NixOS + home-manager |
| `vizzia` | NixOS (Framework 13, AMD 7040) | NixOS + home-manager |

## Structure

```
hosts/          # system-level config per machine
home/           # home-manager config per machine
modules/
├── system/     # shared NixOS/Darwin system modules
└── home/       # shared home-manager modules
overlays/       # custom package overlays
scripts/        # build/activation scripts
```

## Usage

```bash
make mbp-switch   # build + switch macOS
make zeus-switch  # build + switch zeus (run on zeus)
make mbp-build    # dry-run macOS build
make zeus-build   # dry-run zeus build
make check        # validate flake
make update       # update all inputs
make gc           # garbage collect old generations
```

## Setup

### macOS

1. Install [Nix](https://determinate.systems/posts/determinate-nix-installer) via Determinate Systems installer
2. Run `make mbp-switch`

### NixOS

```bash
sudo nixos-rebuild switch --flake .#zeus
```

## Updating nixpkgs pins

Both `nixpkgs-stable` and `nixpkgs-unstable` are pinned to specific commits in `flake.nix`.

```bash
# Update a single input
nix flake lock --update-input nixpkgs-unstable

# Update all inputs
make update
```

Update the date comment in `flake.nix` when changing a pin.
