# Flake Structure

Flakes are Nix's answer to reproducibility and composability. A flake is a directory with a `flake.nix` that declares its inputs and outputs in a standardized way.

## The minimal flake

```nix
{
  description = "A minimal flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = { self, nixpkgs }: {
    # your outputs here
  };
}
```

That's it. Three top-level attributes: `description`, `inputs`, `outputs`.

## `inputs` — where things come from

Inputs declare external dependencies. Each input is fetched and locked:

```nix
inputs = {
  # From GitHub:
  nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  # A specific commit:
  nixpkgs.url = "github:NixOS/nixpkgs/4ea98378ec0cfebcecb3eff00dd4c9635ccc695f";

  # Another flake:
  home-manager.url = "github:nix-community/home-manager/master";

  # From a local path:
  mylib.url = "path:./lib";

  # A non-flake input (just fetch, no flake.nix needed):
  my-config = {
    url = "github:user/dotfiles";
    flake = false;
  };
};
```

## `outputs` — what this flake provides

`outputs` is a **function** that receives the resolved inputs and returns an attrset:

```nix
outputs = { self, nixpkgs, home-manager, ... }: {
  # Standard output attributes (covered in lesson 03)
};
```

The first argument is always `self` — a reference to this flake's own outputs. This enables self-referential configurations.

## `self` — the flake referring to itself

`self` has special attributes:

```nix
outputs = { self, nixpkgs }: {
  # self.outPath — path to the flake source (in the store)
  # self.rev — git revision (if in a git repo with clean tree)
  # self.lastModified — timestamp of the last git commit
  # self.sourceInfo — metadata about the source
};
```

`self.rev` is only set when the working tree is clean (all changes committed). Otherwise it's absent. This is useful for embedding version info in builds.

## Your flake.nix dissected

```nix
{
  description = "home-manager configuration for linux, mac and raspberry pi";

  inputs = {
    # Pinned to a specific commit:
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/4ea98378...";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";  # ← dedup (lesson 02)
    };

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs-unstable";  # ← dedup
    };
  };

  # The outputs function receives all inputs:
  outputs = inputs@{ self, darwin, nixpkgs-unstable, home-manager, ... }:
  {
    nixosConfigurations = { ... };
    darwinConfigurations = { ... };
  };
}
```

### The `inputs@` pattern

```nix
outputs = inputs@{ self, darwin, nixpkgs-unstable, home-manager, ... }:
```

This destructures the inputs AND binds the whole set to `inputs`. Your modules then receive `inputs` via `specialArgs`:

```nix
specialArgs = { inherit inputs; };
```

So any module can access `inputs.nixpkgs-unstable`, `inputs.home-manager`, etc.

## Flake evaluation model

1. Nix reads `flake.nix`
2. Fetches all inputs (using `flake.lock` for exact versions)
3. Calls `outputs` with the fetched inputs
4. Returns the requested output attribute

Everything is **pure** — no `<nixpkgs>` channel lookups, no environment variables, no impure `fetchurl` without hashes. This is why flakes are reproducible.

## Key takeaways

1. **`flake.nix` has three parts**: description, inputs, outputs
2. **`outputs` is a function** from inputs to an attrset of derivations/configs
3. **`self`** lets the flake reference its own outputs and source
4. **`inputs@{ ... }`** gives you both destructured names and the whole set
5. **Flakes are pure** — no channels, no env vars, reproducible by construction

## Exercises

See [exercises/e01-flake-structure.nix](exercises/e01-flake-structure.nix)
