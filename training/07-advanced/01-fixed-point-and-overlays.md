# Fixed Points and Overlays

nixpkgs is a **fixed point**. Understanding `fix` unlocks deep understanding of overlays, recursive package sets, and why `final`/`prev` work the way they do.

## What is a fixed point?

A fixed point of a function `f` is a value `x` where `f(x) = x`.

```
f(x) = x
```

In math: the fixed point of `f(x) = x^2` is `x = 1` because `f(1) = 1`.

## `lib.fix` — computing fixed points

```nix
fix = f: let x = f x; in x;
```

That's it. One line. Let it sink in.

```nix
nix-repl> fix = f: let x = f x; in x

nix-repl> fix (self: { a = 1; b = self.a + 1; })
{ a = 1; b = 2; }
```

How this works:
1. `x = f x` — `x` is defined as `f` applied to itself (circular!)
2. Laziness saves us — `x` is a thunk, not evaluated immediately
3. When you access `x.a`, Nix evaluates just enough of `f x` to find `a`
4. When you access `x.b`, Nix evaluates `self.a + 1`, which forces `x.a = 1`

Without laziness, `let x = f x` would be infinite recursion. With laziness, it's a self-referential data structure.

## Why nixpkgs is a fixed point

Conceptually, nixpkgs is:

```nix
pkgs = fix (self: {
  hello = callPackage ./hello { inherit (self) stdenv; };
  stdenv = ...;
  git = callPackage ./git { inherit (self) openssl perl; };
  openssl = callPackage ./openssl { inherit (self) stdenv; };
  # ... 100,000 more
});
```

Every package can reference any other package through `self`. The fixed point makes this circular reference work.

## How overlays use fixed points

An overlay is `final: prev: { ... }`. In the fixed-point framework:

```nix
applyOverlays = baseF: overlays:
  let
    # Compose the base function with all overlays:
    composedF = builtins.foldl'
      (f: overlay: self: let prev = f self; in prev // overlay self prev)
      baseF
      overlays;
  in
    fix composedF;
```

- **`final`** = the fixed point (`self` in `fix`) — the FINAL package set after all overlays
- **`prev`** = the package set from the previous layer (before this overlay)

## Building intuition with a simple example

```nix
let
  fix = f: let x = f x; in x;

  # Base "package set":
  base = self: {
    a = 1;
    b = self.a + 10;    # b depends on a through the fixed point
    c = self.b + 100;   # c depends on b
  };

  # No overlays — just the base:
  result1 = fix base;
  # { a = 1; b = 11; c = 111; }

  # Now apply an overlay that changes `a`:
  overlay = final: prev: {
    a = 2;  # change a from 1 to 2
  };

  # Apply overlay:
  withOverlay = self:
    let prev = base self;
    in prev // overlay self prev;

  result2 = fix withOverlay;
  # { a = 2; b = 12; c = 112; }
  # Changing a to 2 automatically propagated to b and c!
in
  { inherit result1 result2; }
```

This is the magic: changing `a` in an overlay automatically updates everything that depends on `a`, because they all go through the fixed point `self`/`final`.

## Why `final.x` in overlays causes infinite recursion

```nix
final: prev: {
  hello = final.hello.overrideAttrs (old: { ... });
  # INFINITE RECURSION!
}
```

`final.hello` IS what this overlay is defining. You're saying "hello = f(hello)" where `f` is eager — it needs the value to compute the value. Use `prev.hello` to get the value from before this overlay.

## When `final` IS correct

```nix
final: prev: {
  hello = prev.hello.overrideAttrs (old: {
    buildInputs = [ final.openssl ];  # ← correct!
  });
}
```

`final.openssl` is fine because we're not defining `openssl` in this overlay — we want the final version of openssl (which might be modified by another overlay).

## Two-layer overlay system

```nix
let
  fix = f: let x = f x; in x;

  base = self: {
    greeting = "hello";
    message = "${self.greeting}, ${self.target}!";
    target = "world";
  };

  overlay1 = final: prev: {
    target = "Nix";
  };

  overlay2 = final: prev: {
    greeting = "Bonjour";
  };

  apply = base: overlays:
    fix (self:
      builtins.foldl'
        (prev: overlay: prev // overlay self prev)
        (base self)
        overlays
    );

  result = apply base [ overlay1 overlay2 ];
  # { greeting = "Bonjour"; message = "Bonjour, Nix!"; target = "Nix"; }
in
  result
```

Both overlays' changes propagate through `message` because `message` uses `self.greeting` and `self.target`.

## Key takeaways

1. **`fix = f: let x = f x; in x`** — computes a fixed point using laziness
2. **nixpkgs IS a fixed point** — packages reference each other through `self`
3. **`final` = the fixed point** (all overlays applied); **`prev` = previous layer**
4. **Use `prev` for what you're modifying** to avoid infinite recursion
5. **Changes propagate automatically** because everything goes through the fixed point
6. **Laziness is essential** — without it, the circular reference would diverge

## Exercises

See [exercises/e01-fixed-point.nix](exercises/e01-fixed-point.nix)
