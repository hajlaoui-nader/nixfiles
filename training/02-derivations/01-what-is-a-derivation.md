# What is a Derivation?

A derivation is the core concept of Nix. Everything Nix does — building packages, generating configs, creating system images — comes down to derivations.

## The mental model

A derivation is a **pure function from inputs to a store output**:

```
inputs (source code, dependencies, build script) → /nix/store/<hash>-<name>
```

The key insight: if inputs don't change, the output doesn't change. This is what makes Nix reproducible.

## The `.drv` file

When you write a derivation in Nix, it gets serialized to a `.drv` file in the store. This file is a complete, content-addressed description of what to build.

```bash
# Show the .drv for a package:
nix derivation show nixpkgs#hello
```

Output (simplified):

```json
{
  "/nix/store/abc123-hello-2.12.1.drv": {
    "args": ["-e", "/nix/store/xyz-builder.sh"],
    "builder": "/nix/store/...-bash-5.2/bin/bash",
    "env": {
      "buildInputs": "",
      "name": "hello-2.12.1",
      "out": "/nix/store/...-hello-2.12.1",
      "src": "/nix/store/...-hello-2.12.1.tar.gz",
      "system": "aarch64-darwin"
    },
    "inputDrvs": { ... },
    "inputSrcs": [ ... ],
    "outputs": {
      "out": { "path": "/nix/store/...-hello-2.12.1" }
    },
    "system": "aarch64-darwin"
  }
}
```

## Anatomy of a .drv

| Field | Meaning |
|-------|---------|
| `builder` | The executable that runs the build (usually bash) |
| `args` | Arguments passed to the builder |
| `system` | Platform to build on (`x86_64-linux`, `aarch64-darwin`, etc.) |
| `env` | Environment variables available during the build |
| `inputDrvs` | Other derivations this one depends on (build-time deps) |
| `inputSrcs` | Source files needed |
| `outputs` | The store paths that will be produced |

## The hashing equation

The output store path is determined by:

```
hash(name, system, builder, args, env, inputDrvs, inputSrcs)
```

Change ANY input → different hash → different output path. This is why:
- Changing a dependency rebuilds everything that depends on it
- Two builds with identical inputs produce identical outputs
- You can share build results between machines (binary caches)

## Derivation vs build output

A derivation is a **plan**. The build output is the **result**.

```bash
# The derivation (the plan):
/nix/store/abc123-hello-2.12.1.drv

# The build output (the result):
/nix/store/xyz789-hello-2.12.1/
├── bin/
│   └── hello
└── share/
    └── ...
```

You can have a `.drv` without building it (just the plan). You can only have the output after building.

## Instantiation vs realization

- **Instantiate**: Evaluate Nix code → produce `.drv` files
- **Realize**: Execute the build described by a `.drv` → produce the output

```bash
# Old commands (still work):
nix-instantiate   # evaluate → .drv
nix-store -r      # build .drv → output

# New commands:
nix eval          # evaluate (no .drv)
nix build         # evaluate + build
```

## Inspecting derivations

```bash
# Show the derivation as JSON:
nix derivation show nixpkgs#hello

# Show the output path without building:
nix eval nixpkgs#hello.outPath

# Show all inputs of a derivation:
nix derivation show nixpkgs#hello | jq '.[].inputDrvs | keys'

# Compare two derivation hashes:
nix eval nixpkgs#hello.drvPath
nix eval nixpkgs#cowsay.drvPath
```

## Key takeaways

1. **A derivation is a pure function** from inputs to a store path
2. **`.drv` files** are the serialized, content-addressed build plans
3. **Output path = hash of all inputs** — change anything, get a different path
4. **Instantiate** creates the plan; **realize** executes it
5. Everything in Nix — packages, configs, system images — is a derivation

## Exercises

See [exercises/e01-inspect-derivation.sh](exercises/e01-inspect-derivation.sh)
