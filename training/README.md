# Nix Mastery Training

A progressive, hands-on curriculum for deeply understanding how Nix works under the hood — not just copy-pasting configs.

## Prerequisites

- Nix installed (Determinate Systems installer recommended)
- Familiarity with using `nix build`, `nix develop`, `home-manager`, `nix-darwin`
- Access to this repository (exercises reference real files from this repo)
- A terminal with `nix eval`, `nix repl`, and `nix-store` available

## How to use

Each module is a folder (`01-language/`, `02-derivations/`, etc.) containing:
- **Lesson files** (`.md`): Theory with inline examples you can paste into `nix eval` or `nix repl`
- **Exercise files** (`.nix` or `.sh` in `exercises/`): Runnable files with instructions in comments

### Running exercises

```bash
# Nix expression exercises
nix eval -f training/01-language/exercises/e01-types.nix

# Shell exercises (store inspection, etc.)
bash training/03-store/exercises/e01-store-paths.sh

# Flake exercises (from within the exercise directory)
cd training/06-flakes/exercises/minimal-flake && nix build
```

### Conventions

- `# TODO:` marks places where you need to write or fix code
- `# EXPECTED:` shows what the output should be
- `# HINT:` gives you a nudge without spoiling the answer
- Exercises build on each other within a module — do them in order

## Curriculum

| Module | Topic | Level | Est. time |
|--------|-------|-------|-----------|
| 01 | [Language fundamentals](01-language/) | Beginner | ~4h |
| 02 | [Derivations](02-derivations/) | Intermediate | ~4h |
| 03 | [The Nix store](03-store/) | Intermediate | ~2h |
| 04 | [nixpkgs](04-nixpkgs/) | Intermediate | ~3h |
| 05 | [Module system](05-module-system/) | Intermediate-Advanced | ~4h |
| 06 | [Flakes](06-flakes/) | Intermediate | ~3h |
| 07 | [Advanced topics](07-advanced/) | Advanced | ~3h |

## Repo files referenced in exercises

| File | Used in |
|------|---------|
| `flake.nix` | 06-flakes (annotate each line) |
| `overlays/direnv-overlay.nix` | 02-derivations (phases), 04-nixpkgs (overlays) |
| `modules/home/git.nix` | 05-module-system (module anatomy) |
| `modules/home/common.nix` | 01-language (foldl', attrset patterns) |
| `home/mbp2023.nix` | 01-language (destructuring), 05-module-system (imports) |
| `hosts/mbp2023/system.nix` | 04-nixpkgs (overlays in practice), 07-advanced (rebuild internals) |
