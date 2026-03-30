# Garbage Collection and GC Roots

The Nix store grows over time. Garbage collection reclaims space by removing store paths that nothing references.

## GC roots

A **GC root** is a store path that should be kept alive. Everything reachable from a GC root (its closure) is protected from garbage collection.

GC roots are symlinks in `/nix/var/nix/gcroots/`:

```bash
# List all GC roots:
nix-store --gc --print-roots
```

Common GC roots:
- **System profiles**: `/nix/var/nix/profiles/system-*` (NixOS/nix-darwin)
- **User profiles**: `/nix/var/nix/profiles/per-user/<user>/profile-*`
- **Home Manager generations**: `~/.local/state/nix/profiles/home-manager-*`
- **`result` symlinks**: Any `result` symlink created by `nix build`

## The `result` symlink

When you run `nix build`, it creates a `result` symlink:

```bash
nix build nixpkgs#hello
ls -la result
# result -> /nix/store/...-hello-2.12.1
```

This symlink is registered as a GC root. The built package won't be collected until you delete `result`.

```bash
# These are also GC roots:
nix-store --gc --print-roots | grep result
```

Use `--no-link` to build without creating a GC root:

```bash
nix build nixpkgs#hello --no-link
```

## Generations

System and user profiles keep numbered generations:

```bash
# List home-manager generations:
home-manager generations

# List nix-darwin generations:
darwin-rebuild --list-generations

# List NixOS generations:
nixos-rebuild list-generations
```

Each generation is a GC root. Old generations protect old versions of packages from collection.

## Running garbage collection

```bash
# Delete unreachable store paths:
nix store gc

# Dry run — see what would be deleted:
nix store gc --dry-run

# Delete old generations first, then GC:
# (removes all but the current generation)
nix profile wipe-history

# Delete generations older than 7 days:
nix profile wipe-history --older-than 7d

# Old-style commands (still work):
nix-collect-garbage
nix-collect-garbage -d         # delete all old generations first
nix-collect-garbage --delete-older-than 30d
```

## The GC algorithm

1. Start with all GC roots
2. Trace all references transitively (the closure)
3. Everything NOT in any closure is garbage → delete it

This is a simple mark-and-sweep. It's safe — a path is only deleted if nothing references it.

## Optimizing the store

```bash
# Hard-link identical files in the store (saves disk space):
nix store optimise

# Check store integrity:
nix store verify --all
```

`nix store optimise` finds files with identical content across different store paths and replaces them with hard links. This is safe because store paths are immutable.

## Your nixfiles and GC

In your `hosts/mbp2023/system.nix`, there's a commented-out GC config:

```nix
# nix.gc = {
#   automatic = true;
#   interval = { Weekday = 0; Hour = 0; Minute = 0; };
#   options = "--delete-older-than 1w";
# };
```

And in the `Makefile`:

```makefile
make gc           # garbage collect old generations
make generations  # list system generations
```

## Key takeaways

1. **GC roots** protect store paths from garbage collection
2. **`result` symlinks** are GC roots — delete them when you don't need them
3. **Generations** are GC roots — old generations keep old packages alive
4. **`nix store gc`** only deletes unreachable paths (safe)
5. **Delete old generations first** (`nix profile wipe-history`) to reclaim the most space
6. **`nix store optimise`** deduplicates files across store paths

## Exercises

See [exercises/e03-gc.sh](exercises/e03-gc.sh)
