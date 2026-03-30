# Store Paths and Hashing

Every path in `/nix/store/` follows a strict naming convention. Understanding how these paths are computed is key to understanding Nix's reproducibility guarantees.

## The store path format

```
/nix/store/<hash>-<name>
           ^^^^^^  ^^^^
           32 chars  from the derivation's `name` attribute
           (base32)
```

Example: `/nix/store/qg8crls3ryga01h3kbxp47c25cbm4jcm-hello-2.12.1`

## Input-addressed derivations (the default)

For regular derivations, the output hash is computed from **all inputs**:

```
hash = truncate(sha256(
  "output:out",
  sha256(serialized .drv file),
  name
))
```

The `.drv` file includes:
- The builder path
- All arguments
- All environment variables
- All input derivation paths (which are themselves content-addressed)
- The system string

So the hash captures the **entire dependency tree**. Changing anything upstream changes the hash.

## NAR — Nix Archive format

To hash a directory, Nix serializes it into a **NAR** (Nix Archive):

```bash
# Serialize a store path to NAR:
nix-store --dump /nix/store/...-hello-2.12.1 > hello.nar

# Show NAR info:
nix path-info --json nixpkgs#hello
```

NAR is a deterministic serialization format:
- Files are sorted by name
- Timestamps are ignored
- Permissions are normalized (executable or not)
- No user/group information

This ensures two builds producing the same files always produce the same NAR hash, regardless of filesystem metadata.

## Fixed-output derivations

Some derivations need network access (downloading source code). These use a **fixed-output hash** — you specify the expected hash of the result:

```nix
pkgs.fetchurl {
  url = "https://example.com/source.tar.gz";
  hash = "sha256-abc123...";
}
```

For fixed-output derivations:
- The build **has network access** (unlike normal derivations)
- Nix verifies the output matches the declared hash
- The store path is computed from the hash alone, not the inputs

This is why changing the URL but keeping the same hash gives the same store path.

## Seeing hashes change

```bash
# Build hello:
nix eval --raw nixpkgs#hello.outPath
# /nix/store/...-hello-2.12.1

# Now change the name:
nix eval --raw '(
  (import <nixpkgs> {}).hello.overrideAttrs { pname = "hello-renamed"; }
).outPath'
# /nix/store/DIFFERENT-hello-renamed-2.12.1

# The hash changed because the name attribute changed,
# even though the actual build would produce identical binaries!
```

## Content-addressed store (experimental)

Nix is working on a **content-addressed store** where the output hash is computed from the actual build output, not the inputs. This would mean:
- Two different derivations producing identical output → same store path
- Fewer rebuilds when non-essential inputs change

This is still experimental (behind `ca-derivations` feature flag).

## Key takeaways

1. **Store paths = hash of inputs** (for regular derivations)
2. **NAR format** ensures deterministic directory hashing
3. **Fixed-output derivations** hash the output, not the inputs — enabling network access
4. **Any input change** → different hash → different store path → rebuild
5. The hash captures the **entire dependency tree**, not just direct inputs

## Exercises

See [exercises/e01-store-paths.sh](exercises/e01-store-paths.sh)
