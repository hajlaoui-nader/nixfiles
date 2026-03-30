# Outputs Schema

The `outputs` function returns an attrset with standardized attribute names. Nix tooling knows how to find and use each one.

## Standard output attributes

```nix
outputs = { self, nixpkgs }: {
  # ── Packages ──────────────────────────────────────────────────────
  packages.x86_64-linux.default = <derivation>;
  packages.x86_64-linux.myApp = <derivation>;
  packages.aarch64-darwin.default = <derivation>;

  # ── Dev shells ────────────────────────────────────────────────────
  devShells.x86_64-linux.default = <derivation>;

  # ── NixOS configurations ─────────────────────────────────────────
  nixosConfigurations.myHost = <nixos-system>;

  # ── nix-darwin configurations ─────────────────────────────────────
  darwinConfigurations.myMac = <darwin-system>;

  # ── Home Manager configurations ──────────────────────────────────
  homeConfigurations.myUser = <home-config>;

  # ── Checks (run by `nix flake check`) ────────────────────────────
  checks.x86_64-linux.myTest = <derivation>;

  # ── Overlays ──────────────────────────────────────────────────────
  overlays.default = final: prev: { ... };
  overlays.myOverlay = final: prev: { ... };

  # ── NixOS modules ────────────────────────────────────────────────
  nixosModules.default = { ... };
  nixosModules.myModule = { config, lib, ... }: { ... };

  # ── Templates ─────────────────────────────────────────────────────
  templates.default = { path = ./template; description = "..."; };

  # ── Apps (runnable) ───────────────────────────────────────────────
  apps.x86_64-linux.default = {
    type = "app";
    program = "${self.packages.x86_64-linux.myApp}/bin/myapp";
  };

  # ── Formatter ─────────────────────────────────────────────────────
  formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
};
```

## Per-system pattern

Many outputs are per-system (`x86_64-linux`, `aarch64-darwin`, etc.):

```nix
# Manual (what you see in simple flakes):
packages.x86_64-linux.default = ...;
packages.aarch64-darwin.default = ...;

# With a helper to avoid repetition:
let
  forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-darwin" ];
in {
  packages = forAllSystems (system:
    let pkgs = nixpkgs.legacyPackages.${system};
    in {
      default = pkgs.hello;
    }
  );
};
```

## `nix flake show` — inspect outputs

```bash
nix flake show
```

Output:

```
├── darwinConfigurations
│   └── mbp2023
├── nixosConfigurations
│   └── zeus
└── ...
```

This shows the structure without evaluating derivations (mostly).

## How commands map to outputs

| Command | Output attribute |
|---------|-----------------|
| `nix build .#foo` | `packages.<system>.foo` |
| `nix build .` | `packages.<system>.default` |
| `nix develop` | `devShells.<system>.default` |
| `nix run .#foo` | `apps.<system>.foo` or `packages.<system>.foo` |
| `nix flake check` | `checks.<system>.*` |
| `nixos-rebuild --flake .#host` | `nixosConfigurations.host` |
| `darwin-rebuild --flake .#host` | `darwinConfigurations.host` |
| `home-manager --flake .#user` | `homeConfigurations.user` |

## Your flake's outputs

Your `flake.nix` currently exports:

```nix
outputs = inputs@{ self, darwin, nixpkgs-unstable, home-manager, ... }: {
  nixosConfigurations.zeus = ...;
  darwinConfigurations.mbp2023 = ...;
};
```

You could extend it with:

```nix
{
  # A check that verifies your flake evaluates:
  checks.aarch64-darwin.build = self.darwinConfigurations.mbp2023.system;

  # Export your overlays for other flakes to use:
  overlays.direnv-fix = import ./overlays/direnv-overlay.nix;

  # A dev shell for working on this repo:
  devShells.aarch64-darwin.default = nixpkgs-unstable.legacyPackages.aarch64-darwin.mkShell {
    packages = [ /* tools for editing nix */ ];
  };
}
```

## `checks` — flake-level tests

Checks are derivations that `nix flake check` builds. If any fail, the check fails:

```nix
checks.x86_64-linux.formatting = pkgs.runCommand "check-formatting" {} ''
  cd ${self}
  ${pkgs.nixfmt-rfc-style}/bin/nixfmt --check **/*.nix
  touch $out
'';
```

## `overlays` — share modifications

Exporting overlays lets other flakes use your customizations:

```nix
# Your flake:
overlays.default = import ./overlays/direnv-overlay.nix;

# Another flake consuming it:
inputs.nixfiles.url = "github:you/nixfiles";
# Then in nixpkgs.overlays: [ inputs.nixfiles.overlays.default ]
```

## Key takeaways

1. **Output names are standardized** — Nix tools know where to find things
2. **Per-system outputs** use `packages.<system>.*` pattern
3. **`nix flake show`** displays the output tree
4. **`checks`** are derivations that must succeed for `nix flake check`
5. **Export overlays and modules** to make your flake composable

## Exercises

See [exercises/e03-outputs.sh](exercises/e03-outputs.sh)
