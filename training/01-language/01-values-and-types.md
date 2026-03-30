# Values and Types

Nix has exactly **7 types**. That's it. No classes, no objects, no mutation.

## The 7 types

### 1. Integer

```nix
nix-repl> 42
42

nix-repl> builtins.typeOf 42
"int"

nix-repl> 3 + 4
7

nix-repl> 7 / 2    # integer division!
3
```

### 2. Float

```nix
nix-repl> 3.14
3.14

nix-repl> builtins.typeOf 3.14
"float"

nix-repl> 7.0 / 2
3.5
```

Integers and floats coerce when mixed:

```nix
nix-repl> 1 + 1.0
2.0
```

### 3. Boolean

```nix
nix-repl> true && false
false

nix-repl> builtins.typeOf true
"bool"

nix-repl> if true then "yes" else "no"
"yes"
```

`if` is an **expression** in Nix — it always returns a value. There is no `if` without `else`.

### 4. String

```nix
nix-repl> "hello"
"hello"

nix-repl> builtins.typeOf "hello"
"string"
```

**String interpolation** with `${}`:

```nix
nix-repl> let name = "world"; in "hello ${name}"
"hello world"
```

**Multi-line strings** use `''` (two single quotes):

```nix
nix-repl> ''
  line one
  line two
''
"line one\nline two\n"
```

Multi-line strings strip common leading whitespace. This is why Nix configs look clean.

**Coercion**: Only strings, paths, and derivations can be interpolated. Numbers cannot:

```nix
nix-repl> let x = 42; in "value is ${x}"
# ERROR: cannot coerce an integer to a string

nix-repl> let x = 42; in "value is ${toString x}"
"value is 42"
```

### 5. Path

```nix
nix-repl> /tmp/foo
/tmp/foo

nix-repl> builtins.typeOf /tmp/foo
"path"

nix-repl> ./relative/path    # resolved relative to the file containing it
/current/dir/relative/path
```

Paths are NOT strings. They are a distinct type. When interpolated into a string, the file gets **copied to the Nix store**:

```nix
nix-repl> "${./some-file.txt}"
"/nix/store/abc123-some-file.txt"
```

This is a critical concept — we'll explore it deeply in lesson 05.

### 6. Null

```nix
nix-repl> null
null

nix-repl> builtins.typeOf null
"null"

nix-repl> null == null
true
```

### 7. List

```nix
nix-repl> [ 1 2 3 ]
[ 1 2 3 ]

nix-repl> builtins.typeOf [ 1 2 3 ]
"list"
```

Lists are **space-separated**, not comma-separated. Lists are heterogeneous:

```nix
nix-repl> [ 1 "hello" true null ]
[ 1 "hello" true null ]
```

Lists are **immutable**. Concatenation creates a new list:

```nix
nix-repl> [ 1 2 ] ++ [ 3 4 ]
[ 1 2 3 4 ]
```

### Bonus: Attribute sets and functions

These are types too (attrsets are `"set"`, functions are `"lambda"`), but they're important enough to get their own lessons.

```nix
nix-repl> builtins.typeOf { a = 1; }
"set"

nix-repl> builtins.typeOf (x: x)
"lambda"
```

## Key takeaways

1. **Nix is expression-oriented** — everything evaluates to a value. There are no statements.
2. **No implicit coercion** between strings and numbers — use `toString`.
3. **Paths are a type** — interpolating them copies files to the store.
4. **Lists are space-separated** — commas are syntax errors.

## Exercises

See [exercises/e01-types.nix](exercises/e01-types.nix)
