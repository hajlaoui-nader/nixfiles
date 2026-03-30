# Functions

Every Nix function takes **exactly one argument**. This single rule explains currying, destructuring, and the `@`-pattern.

## Lambda syntax

```nix
nix-repl> x: x + 1
«lambda»

nix-repl> (x: x + 1) 5
6
```

There's no `function` keyword. No `def`. No `fn`. Just `arg: body`.

## Multi-argument functions (currying)

Since functions take one argument, "multi-argument" functions are just nested lambdas:

```nix
nix-repl> add = a: b: a + b

# This is actually:
nix-repl> add = a: (b: a + b)

nix-repl> add 3 4
7

# Partial application works naturally:
nix-repl> add3 = add 3
nix-repl> add3 4
7
```

## Destructuring (pattern matching on attrsets)

Most Nix functions you'll see take an attrset and destructure it:

```nix
nix-repl> f = { a, b }: a + b
nix-repl> f { a = 1; b = 2; }
3
```

This is strict — passing extra keys is an error:

```nix
nix-repl> f { a = 1; b = 2; c = 3; }
# ERROR: function at ... called with unexpected argument 'c'
```

### The `...` (ellipsis)

Add `...` to accept and ignore extra keys:

```nix
nix-repl> f = { a, b, ... }: a + b
nix-repl> f { a = 1; b = 2; c = 3; }
3
```

This is why almost every module in your nixfiles starts with `{ pkgs, ... }:` — the `...` silently accepts all the other arguments the module system passes.

### Default values

```nix
nix-repl> f = { a, b ? 10 }: a + b
nix-repl> f { a = 5; }
15
nix-repl> f { a = 5; b = 20; }
25
```

### The `@`-pattern

Bind the entire attrset to a name while also destructuring:

```nix
nix-repl> f = { a, b, ... } @ args: a + b + (args.c or 0)
nix-repl> f { a = 1; b = 2; c = 3; }
6
```

Look at your `home/mbp2023.nix`:

```nix
{ pkgs, inputs, ... }:
```

This destructures `pkgs` and `inputs` from the argument set, and `...` accepts everything else (like `config`, `lib`, etc.).

## Function composition

Nix has no built-in compose operator, but you can write one:

```nix
compose = f: g: x: f (g x)
```

## `builtins` — built-in functions

Nix ships with ~100 built-in functions. Key ones:

```nix
builtins.map (x: x * 2) [ 1 2 3 ]          # [ 2 4 6 ]
builtins.filter (x: x > 2) [ 1 2 3 4 ]      # [ 3 4 ]
builtins.foldl' (acc: x: acc + x) 0 [ 1 2 3 ] # 6
builtins.length [ 1 2 3 ]                     # 3
builtins.head [ 1 2 3 ]                       # 1
builtins.tail [ 1 2 3 ]                       # [ 2 3 ]
builtins.elem 2 [ 1 2 3 ]                     # true
builtins.attrNames { a = 1; b = 2; }          # [ "a" "b" ]
```

Note `foldl'` (with the prime) — it's strict (eager). Plain `foldl` is lazy and can blow the stack. Always use `foldl'`.

Look at your `modules/home/common.nix` line 38 — it uses `builtins.foldl'` to build snippet file entries.

## Key takeaways

1. **All functions are single-argument** — multi-arg is just currying
2. **`{ a, b, ... }:`** is pattern matching, not a special syntax
3. **`...` is essential** in the module system — it absorbs extra arguments
4. **`@`-pattern** gives you both the destructured names and the whole set
5. **Use `foldl'`**, never `foldl`

## Exercises

See [exercises/e02-functions.nix](exercises/e02-functions.nix)
