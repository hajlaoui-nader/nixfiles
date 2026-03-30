# Attribute Sets

Attribute sets (attrsets) are the backbone of Nix. Packages, configurations, modules — everything is an attrset.

## Basics

```nix
nix-repl> { a = 1; b = 2; }
{ a = 1; b = 2; }

nix-repl> { a = 1; b = 2; }.a
1
```

**Semicolons are required** after every attribute. Forgetting them is the #1 syntax error for beginners.

## Nested access

```nix
nix-repl> { a.b.c = 1; }
{ a = { b = { c = 1; }; }; }

nix-repl> { a.b.c = 1; }.a.b.c
1
```

Dotted attribute paths are syntactic sugar for nested sets.

## The `//` (update) operator

Creates a new attrset by merging right into left. Right wins on conflicts:

```nix
nix-repl> { a = 1; b = 2; } // { b = 3; c = 4; }
{ a = 1; b = 3; c = 4; }
```

**`//` is shallow** — it does NOT deep-merge:

```nix
nix-repl> { a = { x = 1; y = 2; }; } // { a = { y = 3; }; }
{ a = { y = 3; }; }
# a.x is GONE — the entire `a` was replaced
```

This is a frequent source of bugs. The module system exists partly to solve this with proper deep merging.

## The `?` operator

Check if an attribute exists:

```nix
nix-repl> { a = 1; } ? a
true

nix-repl> { a = 1; } ? b
false

nix-repl> { a.b = 1; } ? a.b
true
```

The `or` keyword provides defaults for missing keys:

```nix
nix-repl> { a = 1; }.b or 42
42
```

## `rec` — recursive attribute sets

Normally, attributes can't reference each other. `rec` changes that:

```nix
nix-repl> rec { a = 1; b = a + 1; }
{ a = 1; b = 2; }

# Without rec:
nix-repl> { a = 1; b = a + 1; }
# ERROR: undefined variable 'a'
```

**Warning**: `rec` can cause infinite recursion if you create circular references. Prefer `let` bindings when possible.

## `mapAttrs`

Transform every value in an attrset:

```nix
nix-repl> builtins.mapAttrs (name: value: value * 2) { a = 1; b = 2; c = 3; }
{ a = 2; b = 4; c = 6; }
```

The function receives both the key name and the value.

## `listToAttrs` and `attrValues`

```nix
nix-repl> builtins.listToAttrs [ { name = "a"; value = 1; } { name = "b"; value = 2; } ]
{ a = 1; b = 2; }

nix-repl> builtins.attrValues { a = 1; b = 2; }
[ 1 2 ]

nix-repl> builtins.attrNames { b = 2; a = 1; }
[ "a" "b" ]    # always sorted alphabetically!
```

## `intersectAttrs` and `removeAttrs`

```nix
nix-repl> builtins.intersectAttrs { a = 1; b = 2; } { b = 20; c = 30; }
{ b = 20; }    # keeps values from the RIGHT, keys from the intersection

nix-repl> builtins.removeAttrs { a = 1; b = 2; c = 3; } [ "b" ]
{ a = 1; c = 3; }
```

## Pattern: building an attrset from a list

This pattern from `modules/home/common.nix` is very common:

```nix
builtins.foldl'
  (acc: key: acc // { "${key}" = something key; })
  { }
  listOfKeys
```

It starts with `{}` and merges in one key-value pair per iteration. You'll see this everywhere in nixpkgs.

## Key takeaways

1. **`//` is shallow merge** — it replaces, not deep-merges
2. **`?` checks existence**, `or` provides defaults
3. **`rec` allows self-reference** but prefer `let` when possible
4. **`builtins.attrNames` sorts alphabetically** — never rely on insertion order
5. **The foldl' + // pattern** builds attrsets incrementally from lists

## Exercises

See [exercises/e03-attrsets.nix](exercises/e03-attrsets.nix)
