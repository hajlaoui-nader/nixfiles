# Paths and Imports

Paths are a first-class type in Nix with some surprising behavior that you need to understand to avoid store pollution and build breakage.

## Path literals

```nix
nix-repl> /tmp/foo              # absolute path
/tmp/foo

nix-repl> ./relative            # relative to the file evaluating it
/current/dir/relative

nix-repl> builtins.typeOf ./foo
"path"
```

Paths must contain at least one slash. `foo` alone is an identifier, not a path.

## Paths vs strings

```nix
nix-repl> "/tmp/foo"        # this is a STRING
"/tmp/foo"

nix-repl> /tmp/foo           # this is a PATH
/tmp/foo
```

The critical difference: **when a path is interpolated into a string, the file/directory is copied to the Nix store**:

```nix
nix-repl> "${./some-file.txt}"
"/nix/store/abc123-some-file.txt"
```

This is intentional — it ensures builds are reproducible by capturing all inputs in the store. But it can surprise you:

```nix
# This copies the ENTIRE current directory to the store:
src = ./.;

# This copies just one file:
configFile = ./config.toml;
```

## `import`

`import` reads and evaluates a Nix file:

```nix
# assuming ./foo.nix contains: { a = 1; b = 2; }
nix-repl> import ./foo.nix
{ a = 1; b = 2; }
```

If you import a directory, Nix looks for `default.nix` inside it:

```nix
import ./some-directory
# equivalent to:
import ./some-directory/default.nix
```

This is why your modules like `../modules/home/zsh` (without `.nix`) work — Nix finds `zsh/default.nix`.

### Import is just evaluation

`import` returns whatever the file evaluates to. If the file contains a function:

```nix
# lib.nix contains: x: x + 1
nix-repl> (import ./lib.nix) 5
6
```

This is exactly how your home config works:

```nix
# In flake.nix:
home-manager.users.naderh = import ./home/mbp2023.nix;

# mbp2023.nix is a function: { pkgs, inputs, ... }: { ... }
# home-manager calls it with { pkgs, inputs, config, lib, ... }
```

### Import chains

Imports can chain — file A imports file B which imports file C:

```nix
# a.nix
{ imports = [ ./b.nix ]; setting = 1; }

# b.nix
{ imports = [ ./c.nix ]; other-setting = 2; }

# c.nix
{ final-setting = 3; }
```

Your nixfiles use this pattern extensively: `mbp2023.nix` imports `common.nix` which imports `packages.nix`, `shell.nix`, etc.

## Path concatenation

Paths support `/` for concatenation:

```nix
nix-repl> /tmp + "/foo"    # path + string = path
/tmp/foo

nix-repl> /tmp + /foo      # ERROR: cannot add two paths
```

And `+` with strings (be careful):

```nix
nix-repl> ./. + "/file.txt"    # path + string = path
/current/dir/file.txt

nix-repl> "./." + "/file.txt"  # string + string = string
"././file.txt"
```

## `builtins.path` — controlled store imports

For more control over what gets copied to the store:

```nix
src = builtins.path {
  path = ./.;
  name = "my-source";
  filter = path: type:
    type != "directory" || baseNameOf path != ".git";
};
```

This copies the current directory but excludes `.git/`.

## `builtins.readFile` and `builtins.readDir`

```nix
nix-repl> builtins.readFile ./some-file.txt
"contents of the file"

nix-repl> builtins.readDir ./.
{ "flake.nix" = "regular"; "modules" = "directory"; ... }
```

`readDir` returns an attrset mapping names to types (`"regular"`, `"directory"`, `"symlink"`).

## Key takeaways

1. **Path interpolation copies to the store** — this is by design for reproducibility
2. **`import` just evaluates a file** — if the file is a function, you get a function back
3. **Importing a directory** looks for `default.nix`
4. **Path + string = path** but string + string = string — be careful with types
5. **Use `builtins.path` with `filter`** when you need to exclude files from store copies

## Exercises

See [exercises/e05-paths-imports.nix](exercises/e05-paths-imports.nix)
