# builtins.derivation — The Only Primitive

There is exactly **one** function in Nix that creates a derivation: `builtins.derivation`. Everything else — `mkDerivation`, `writeShellScriptBin`, `buildGoModule` — is sugar on top.

## The raw derivation function

```nix
builtins.derivation {
  name = "hello";
  system = builtins.currentSystem;
  builder = "/bin/sh";
  args = [ "-c" "echo hello > $out" ];
}
```

This is the simplest possible derivation. It:
1. Runs `/bin/sh -c "echo hello > $out"` inside a sandbox
2. Writes the output to `$out` (a store path Nix provides)
3. Produces `/nix/store/<hash>-hello`

## Required attributes

| Attribute | Meaning |
|-----------|---------|
| `name` | Name of the derivation (appears in the store path) |
| `system` | Platform to build on |
| `builder` | Program to execute |

Everything else is optional and gets passed as environment variables to the builder.

## How `$out` works

Nix computes the output path before the build starts and passes it as `$out`. Your builder must create something at `$out`:

- If `$out` should be a file: `echo "content" > $out`
- If `$out` should be a directory: `mkdir -p $out/bin && cp my-program $out/bin/`

If the builder exits with a non-zero code, or doesn't create `$out`, the build fails.

## Environment variables

Every attribute you pass becomes an environment variable:

```nix
builtins.derivation {
  name = "greeter";
  system = builtins.currentSystem;
  builder = "/bin/sh";
  args = [ "-c" "echo $greeting > $out" ];
  greeting = "hello world";
}
```

Inside the build, `$greeting` is `"hello world"`.

## Derivation as dependency

When you reference one derivation inside another, Nix tracks the dependency:

```nix
let
  dep = builtins.derivation {
    name = "message";
    system = builtins.currentSystem;
    builder = "/bin/sh";
    args = [ "-c" "echo 'hello from dep' > $out" ];
  };
in
builtins.derivation {
  name = "reader";
  system = builtins.currentSystem;
  builder = "/bin/sh";
  args = [ "-c" "cat ${dep} > $out" ];
}
```

`${dep}` interpolates to the store path of `dep`'s output. Nix ensures `dep` is built before `reader`.

## The sandbox

Builds run in a restricted environment:
- **No network access** (unless it's a fixed-output derivation)
- **No access to the host filesystem** (except explicitly declared inputs)
- **No access to environment variables** from the host
- **Deterministic timestamps** and user IDs

This is why Nix builds are reproducible — the sandbox prevents contamination.

On macOS, sandboxing uses `sandbox-exec`. On Linux, it uses namespaces and bind mounts.

## `derivation` vs `builtins.derivation`

They're the same function. `derivation` is a global alias for `builtins.derivation`.

## What the derivation function returns

`derivation` returns an attrset with special attributes:

```nix
nix-repl> d = derivation { name = "test"; system = "x86_64-linux"; builder = "/bin/sh"; }
nix-repl> d.drvPath
"/nix/store/...-test.drv"
nix-repl> d.outPath
"/nix/store/...-test"
nix-repl> d.type
"derivation"
```

When interpolated into a string, a derivation coerces to its `outPath`:

```nix
"${d}" == d.outPath  # true
```

## Key takeaways

1. **`builtins.derivation` is the ONLY primitive** for creating derivations
2. **Every attribute becomes an env var** in the build
3. **`$out` is provided by Nix** — you must create something there
4. **Referencing a derivation** in another creates a dependency edge
5. **Builds are sandboxed** — no network, no host filesystem, deterministic

## Exercises

See [exercises/e02-raw-derivation.nix](exercises/e02-raw-derivation.nix)
