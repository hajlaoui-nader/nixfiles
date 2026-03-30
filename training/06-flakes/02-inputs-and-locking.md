# Inputs and Locking

Flake inputs are fetched once, hashed, and locked in `flake.lock`. This is what makes flakes reproducible across machines and time.

## `flake.lock` — the lockfile

When you first evaluate a flake (or run `nix flake lock`), Nix creates `flake.lock`:

```json
{
  "nodes": {
    "nixpkgs-unstable": {
      "locked": {
        "lastModified": 1711234567,
        "narHash": "sha256-abc123...",
        "owner": "NixOS",
        "repo": "nixpkgs",
        "rev": "4ea98378ec0cfebcecb3eff00dd4c9635ccc695f",
        "type": "github"
      },
      "original": {
        "owner": "NixOS",
        "repo": "nixpkgs",
        "rev": "4ea98378ec0cfebcecb3eff00dd4c9635ccc695f",
        "type": "github"
      }
    }
  }
}
```

Key fields:
- **`rev`**: The exact git commit
- **`narHash`**: SHA-256 of the fetched content (verification)
- **`lastModified`**: Timestamp for cache invalidation

## `follows` — input deduplication

Without `follows`, each input brings its own copy of nixpkgs:

```
your-flake
├── nixpkgs-unstable (commit A)
├── home-manager
│   └── nixpkgs (commit B)  ← DIFFERENT copy!
└── darwin
    └── nixpkgs (commit C)  ← ANOTHER copy!
```

With `follows`, they all share one:

```nix
home-manager = {
  url = "github:nix-community/home-manager/master";
  inputs.nixpkgs.follows = "nixpkgs-unstable";
};
```

Now:

```
your-flake
├── nixpkgs-unstable (commit A)
├── home-manager
│   └── nixpkgs → nixpkgs-unstable  ← SAME as yours
└── darwin
    └── nixpkgs → nixpkgs-unstable  ← SAME as yours
```

Your `flake.nix` does this for both `home-manager` and `darwin`.

### Why `follows` matters

1. **Consistency**: Everyone uses the same nixpkgs, so packages are identical
2. **Disk space**: One copy of nixpkgs instead of three
3. **Build cache hits**: Same inputs = same hashes = shared builds

### When NOT to use `follows`

If an input is tested against a specific nixpkgs version and might break with yours. This is rare but worth knowing.

## Updating inputs

```bash
# Update ALL inputs to latest:
nix flake update

# Update a specific input:
nix flake lock --update-input nixpkgs-unstable

# Update and show what changed:
nix flake update 2>&1 | head -20
```

After updating, `flake.lock` changes with new `rev` and `narHash` values. Commit `flake.lock` to pin the update.

## Pinning to a specific commit

Your flake pins nixpkgs to an exact commit:

```nix
nixpkgs-unstable.url = "github:NixOS/nixpkgs/4ea98378ec0cfebcecb3eff00dd4c9635ccc695f";
```

This is more explicit than using a branch name. With a branch (`nixpkgs-unstable`), `nix flake update` would move to the latest commit. With a pinned commit, you control exactly when to update.

## Inspecting the lock file

```bash
# Show the flake's inputs as a tree:
nix flake metadata

# Show input revisions:
nix flake metadata --json | jq '.locks.nodes | to_entries[] | {key: .key, rev: .value.locked.rev}'

# Verify lock file is up to date:
nix flake lock --no-update-lock-file  # errors if lock needs updating
```

## Input types

```nix
inputs = {
  # GitHub repository:
  foo.url = "github:owner/repo/branch-or-rev";

  # GitLab:
  bar.url = "gitlab:owner/repo";

  # Git URL:
  baz.url = "git+https://example.com/repo.git";

  # Local path (useful for development):
  local.url = "path:../other-flake";

  # Tarball:
  tar.url = "https://example.com/archive.tar.gz";

  # Non-flake input (no flake.nix required):
  data = { url = "github:user/data-repo"; flake = false; };
};
```

## The evaluation cycle

```
flake.nix defines inputs
        ↓
nix flake lock fetches and pins them → flake.lock
        ↓
nix build/eval reads flake.lock, fetches exact versions
        ↓
outputs function is called with fetched inputs
```

Changing `flake.nix` inputs doesn't change what's built until you run `nix flake lock` or `nix flake update`.

## Key takeaways

1. **`flake.lock` pins exact commits and hashes** — reproducible builds
2. **`follows` deduplicates inputs** — one nixpkgs for everything
3. **Pinning to commits** gives you full control over updates
4. **`nix flake update`** refreshes all inputs; `--update-input` refreshes one
5. **Commit `flake.lock`** — it's the reproducibility guarantee

## Exercises

See [exercises/e02-inputs-locking.sh](exercises/e02-inputs-locking.sh)
