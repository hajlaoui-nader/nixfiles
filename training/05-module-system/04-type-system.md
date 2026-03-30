# The Type System

Every option in the module system has a type. Types control validation, merging behavior, and documentation.

## Why types matter

Types aren't just for validation — they determine how values **merge** when multiple modules set the same option:

```nix
# types.listOf: values CONCATENATE
# Module A: home.packages = [ git ];
# Module B: home.packages = [ ripgrep ];
# Result:   home.packages = [ git ripgrep ];

# types.bool: values CONFLICT (must use priority)
# Module A: services.nginx.enable = true;
# Module B: services.nginx.enable = false;
# Result:   ERROR (use mkDefault/mkForce to resolve)
```

## Common types

### Scalar types

```nix
lib.types.bool          # true or false
lib.types.int           # integer
lib.types.float         # floating point
lib.types.str           # string
lib.types.path          # path (store path or filesystem path)
lib.types.port          # integer 0-65535
lib.types.package       # a derivation
```

### Container types

```nix
lib.types.listOf lib.types.str          # list of strings
lib.types.listOf lib.types.package      # list of packages
lib.types.attrsOf lib.types.str         # attrset where all values are strings
lib.types.attrsOf lib.types.int         # attrset where all values are ints
```

### Choice types

```nix
lib.types.enum [ "left" "center" "right" ]   # one of these exact values
lib.types.nullOr lib.types.str               # string or null
lib.types.oneOf [ lib.types.int lib.types.str ]  # int or string
```

### Compound types

```nix
lib.types.either lib.types.int lib.types.str   # int or string
lib.types.coercedTo lib.types.str builtins.toJSON lib.types.attrs
# accepts a string but coerces to attrs via toJSON
```

## `types.submodule` — nested options

Submodules let you define structured, typed nested configuration:

```nix
{ lib, ... }:
{
  options.services.myApp.database = lib.mkOption {
    type = lib.types.submodule {
      options = {
        host = lib.mkOption {
          type = lib.types.str;
          default = "localhost";
        };
        port = lib.mkOption {
          type = lib.types.port;
          default = 5432;
        };
        name = lib.mkOption {
          type = lib.types.str;
        };
      };
    };
  };
}
```

Usage:

```nix
services.myApp.database = {
  host = "db.example.com";
  port = 5432;
  name = "myapp";
};
```

### List of submodules

```nix
options.services.myApp.virtualHosts = lib.mkOption {
  type = lib.types.listOf (lib.types.submodule {
    options = {
      domain = lib.mkOption { type = lib.types.str; };
      root = lib.mkOption { type = lib.types.path; };
    };
  });
  default = [];
};
```

Usage:

```nix
services.myApp.virtualHosts = [
  { domain = "example.com"; root = "/var/www/example"; }
  { domain = "blog.com"; root = "/var/www/blog"; }
];
```

## Merge behavior by type

| Type | Merge behavior |
|------|---------------|
| `bool` | Error on conflict (use priority) |
| `str` | Error on conflict (use priority) |
| `int` | Error on conflict (use priority) |
| `listOf` | Concatenate lists |
| `attrsOf` | Recursively merge attrsets |
| `submodule` | Recursively merge sub-options |
| `enum` | Error on conflict (use priority) |

## Type error messages

When you set a wrong type, you get a clear error:

```
error: A definition for option `services.myApp.port' is not of type `16 bit unsigned integer; between 0 and 65535 (both inclusive)'.
       Definition values:
       - In `/home/user/config.nix': "not-a-number"
```

This tells you exactly which file set the wrong value and what type was expected.

## Creating custom types

You can compose types for domain-specific validation:

```nix
let
  emailType = lib.types.strMatching "^[^@]+@[^@]+$";
in {
  options.user.email = lib.mkOption {
    type = emailType;
    description = "User email address.";
  };
}
```

## Key takeaways

1. **Types control merging**, not just validation
2. **Lists concatenate**, scalars conflict, attrsets deep-merge
3. **`submodule`** enables structured nested configuration
4. **`enum`** restricts to a set of allowed values
5. **Error messages** tell you exactly what's wrong and where
6. **Priority** (`mkDefault`/`mkForce`) resolves scalar conflicts

## Exercises

See [exercises/e04-types.nix](exercises/e04-types.nix)
