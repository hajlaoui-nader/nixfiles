# Laziness

Nix is a **lazy** language. Expressions are not evaluated until their value is needed. This is fundamental to how Nix can define 100,000+ packages in nixpkgs without evaluating all of them.

## Thunks

When Nix encounters an expression, it creates a **thunk** — a promise to compute the value later. The thunk is only forced (evaluated) when something actually needs the result.

```nix
nix-repl> let
           x = throw "boom";  # never evaluated!
           y = 42;
         in y
42
```

The `throw` is never reached because `x` is never used. The thunk for `x` sits there, unevaluated.

## Lazy attribute sets

```nix
nix-repl> let
           s = {
             a = 1;
             b = throw "never reached";
           };
         in s.a
1
```

Only `s.a` is evaluated. `s.b` remains a thunk. This is why nixpkgs can define a massive attrset of packages — accessing `pkgs.git` doesn't evaluate `pkgs.firefox`.

## `builtins.trace` — observe evaluation order

`trace` prints a message to stderr when the expression is forced, then returns its second argument:

```nix
nix-repl> builtins.trace "evaluating x" 42
trace: evaluating x
42
```

Use it to understand when things are evaluated:

```nix
nix-repl> let
           a = builtins.trace "eval a" 1;
           b = builtins.trace "eval b" 2;
           c = builtins.trace "eval c" 3;
         in a + c
trace: eval a
trace: eval c
4
```

Notice: `"eval b"` never appears — `b` was never forced.

## Lazy lists

```nix
nix-repl> let
           xs = [ (builtins.trace "first" 1) (builtins.trace "second" 2) ];
         in builtins.head xs
trace: first
trace: second
1
```

Wait — both traced? That's because **list construction forces all elements** in current Nix. Lists are lazy in their existence but not in their elements once you touch the list.

However, accessing an attrset member does NOT force other members. This is why attrsets are the preferred "lazy container" in Nix.

## `builtins.seq` — force evaluation

`seq` forces evaluation of its first argument, then returns the second:

```nix
nix-repl> builtins.seq (1 + 1) "hello"
"hello"

nix-repl> builtins.seq (throw "boom") "hello"
# ERROR: boom
```

Use `seq` when you need to force an error check before proceeding.

`builtins.deepSeq` forces evaluation recursively through attrsets and lists:

```nix
nix-repl> builtins.deepSeq { a = throw "boom"; } "hello"
# ERROR: boom

nix-repl> builtins.seq { a = throw "boom"; } "hello"
"hello"   # seq only forces the top level — the attrset exists, so it's fine
```

## Infinite structures

Laziness enables infinite data structures:

```nix
nix-repl> let
           repeat = x: [ x ] ++ repeat x;  # infinite list!
         in builtins.head (repeat 42)
42
```

Wait, does this actually work? It depends — Nix evaluates the list spine lazily enough for `head` to work here due to `++` being lazy in its right operand.

A more reliable infinite structure:

```nix
nix-repl> let
           nats = start: { head = start; tail = nats (start + 1); };
           take = n: s: if n == 0 then [] else [ s.head ] ++ take (n - 1) s.tail;
         in take 5 (nats 0)
[ 0 1 2 3 4 ]
```

## Why laziness matters for Nix

1. **nixpkgs performance**: `import <nixpkgs> {}` returns an attrset with 100k+ packages. Without laziness, this would take forever. With laziness, only packages you reference get evaluated.

2. **Module system**: Modules can reference each other's `config` values because evaluation is deferred. `config.services.nginx.enable` is a thunk until something forces it.

3. **Cross-references**: In your `flake.nix`, `self` can reference outputs that haven't been defined yet — laziness makes this possible.

4. **Fixed-point evaluation**: The overlay system uses `fix = f: let x = f x; in x`, which only works because of laziness. We'll cover this in module 07.

## Common laziness pitfalls

### Accidental strictness

`builtins.toJSON` forces deep evaluation:

```nix
nix-repl> builtins.toJSON { a = 1; b = throw "boom"; }
# ERROR: boom
```

### Debugging with trace

`trace` only fires when the expression containing it is forced. If your trace isn't printing, the code path isn't being evaluated.

## Key takeaways

1. **Nix is lazy** — expressions become thunks until forced
2. **Attrset members are independently lazy** — accessing one doesn't force others
3. **`builtins.trace`** lets you observe evaluation order
4. **`builtins.seq`** forces shallow evaluation, **`deepSeq`** forces recursive evaluation
5. **Laziness enables nixpkgs scale** — 100k packages, only evaluate what you need

## Exercises

See [exercises/e06-laziness.nix](exercises/e06-laziness.nix)
