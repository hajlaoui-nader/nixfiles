# References and Closures

How does Nix know which store paths a package needs at runtime? It **scans the output binaries for store path hashes**.

## Runtime reference detection

After a build, Nix scans all output files for strings matching store path hashes. If it finds a hash, it records a **runtime reference** to that store path.

```bash
# Show runtime references of hello:
nix-store -qR $(nix eval --raw nixpkgs#hello.outPath)
```

This might output:

```
/nix/store/...-glibc-2.39
/nix/store/...-hello-2.12.1
```

`hello` references `glibc` because the binary contains the glibc store path as a dynamic library path.

## How scanning works

Nix doesn't understand ELF, Mach-O, or any binary format. It does a simple **substring search** for the 32-character hash prefix of every input derivation's output path.

If `/nix/store/abc12345...-openssl-3.0` was an input and the string `abc12345...` appears anywhere in the output files (even in a binary), Nix records it as a reference.

This is:
- **Conservative**: It catches real references
- **Occasionally over-eager**: A hash might appear by coincidence (rare)
- **Simple**: No format-specific parsing needed

## Closures

A **closure** is the complete set of store paths needed to use a package — the package itself plus all its runtime references, transitively:

```bash
# Show the full closure:
nix-store -qR $(nix eval --raw nixpkgs#hello.outPath)

# Show closure with sizes:
nix path-info -rsSh $(nix eval --raw nixpkgs#hello.outPath)
```

The closure is what gets copied when you:
- Push to a binary cache
- Deploy to another machine
- Create a Docker image with `dockerTools`

## Closure size matters

```bash
# Compare closure sizes:
nix path-info -sSh nixpkgs#hello
nix path-info -sSh nixpkgs#python3
nix path-info -sSh nixpkgs#git

# -s: show NAR size
# -S: show closure size
# -h: human-readable
```

A package might be 1MB, but its closure might be 200MB because of transitive dependencies.

## Accidental reference retention

Sometimes a store path appears in the output by accident — e.g., a compiler path embedded in a binary's debug info, or a build-time tool path in a generated config file.

This bloats the closure. Common fixes:

```nix
# Remove references to specific paths:
disallowedReferences = [ pkgs.cmake ];

# Or strip the reference:
postInstall = ''
  remove-references-to -t ${pkgs.cmake} $out/bin/myapp
'';
```

## `nix why-depends`

Find out **why** a runtime reference exists:

```bash
nix why-depends nixpkgs#hello nixpkgs#glibc
```

This shows the chain of references that creates the dependency.

## Key takeaways

1. **Nix scans output for store path hashes** to detect runtime dependencies
2. **Closures** = transitive set of all runtime dependencies
3. **Closure size** is what matters for deployment and caching
4. **Accidental references** can bloat closures — use `remove-references-to` to fix
5. **`nix why-depends`** helps debug unexpected dependencies

## Exercises

See [exercises/e02-closures.sh](exercises/e02-closures.sh)
