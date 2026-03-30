# let, with, and inherit

These three constructs control scoping in Nix. Understanding them — especially the dangers of `with` — is essential.

## `let ... in`

Introduces local bindings:

```nix
nix-repl> let x = 1; y = 2; in x + y
3
```

Bindings can reference each other (they're mutually recursive):

```nix
nix-repl> let
           a = 1;
           b = a + 1;
           c = b + 1;
         in c
3
```

`let` bindings are the **preferred way** to define local values. They're explicit and their scope is clear.

## `with`

Brings all attributes of a set into scope:

```nix
nix-repl> with { a = 1; b = 2; }; a + b
3
```

### Why `with` can be dangerous

**Problem 1: Shadowing is silent and confusing**

```nix
nix-repl> let a = 10; in with { a = 1; }; a
10   # let WINS over with — but this isn't obvious to readers
```

`let` always shadows `with`. This is by design, but it means code using `with` has non-obvious name resolution.

**Problem 2: You don't know what's in scope**

```nix
with pkgs; [
  git
  ripgrep
  some-typo-package  # Is this a real package? You can't tell without evaluating pkgs.
]
```

Without `with`, a typo gives you `undefined variable`. With `with`, it might silently resolve to something unexpected or fail late.

**Problem 3: Tooling can't analyze it**

Static analysis, LSPs, and code navigation can't resolve names introduced by `with`. They can't tell you "this `git` refers to `pkgs.git`" because it depends on runtime evaluation.

### When `with` is acceptable

Short, well-bounded lists where the contents are obvious:

```nix
home.packages = with pkgs; [
  git
  ripgrep
  fd
];
```

This is fine because the context makes it clear every name comes from `pkgs`.

### Avoid `with` in

- Module-level scope (makes the whole module ambiguous)
- Nested `with` (becomes very hard to reason about)
- Where you're accessing only a few attributes (just use `pkgs.git`)

## `inherit`

`inherit` is pure syntactic sugar. It copies a binding from the surrounding scope:

```nix
# These are identical:
let x = 1; in { inherit x; }
let x = 1; in { x = x; }
# Both produce: { x = 1; }
```

`inherit` from an attrset:

```nix
# These are identical:
{ inherit (pkgs) git ripgrep; }
{ git = pkgs.git; ripgrep = pkgs.ripgrep; }
```

`inherit` in `let`:

```nix
let
  inherit (builtins) map filter;
in
  map (x: x + 1) (filter (x: x > 2) [ 1 2 3 4 ])
```

### `inherit` is NOT `with`

`inherit` is explicit — you name exactly what you're pulling in. `with` dumps everything into scope.

## Scoping rules summary

Resolution order (highest priority first):
1. `let` bindings
2. Function arguments
3. `with` (most recent `with` wins if nested)
4. Built-in constants (`true`, `false`, `null`)

```nix
let a = 1;
in with { a = 2; };
   a
# Result: 1 (let wins)
```

```nix
with { a = 1; };
with { a = 2; };
a
# Result: 2 (inner with wins)
```

## Key takeaways

1. **Prefer `let`** for local bindings — explicit and predictable
2. **`with` is convenient but dangerous** — silent shadowing, no static analysis
3. **`inherit` is just shorthand** for `x = x` or `x = set.x`
4. **`let` always shadows `with`** — never the other way around
5. **In your nixfiles**: `with pkgs;` in package lists is fine; avoid `with` everywhere else

## Exercises

See [exercises/e04-let-with-inherit.nix](exercises/e04-let-with-inherit.nix)
