# Exercise 01: Flake Structure
# This is NOT meant to be run with `nix eval -f`. Instead, read and annotate.
#
# Run: nix flake show path:../.../nixfiles  (from this repo root)
#
# This exercise asks you to annotate your own flake.nix.

# ── Exercise 1: Annotate your flake.nix ─────────────────────────────────
#
# Open ../../flake.nix (the repo root flake) and add mental annotations:
#
# For each line, answer:
# 1. What does `inputs.nixpkgs-unstable.url = "github:..."` do?
#    → Declares a dependency on nixpkgs at a specific commit
#
# 2. What does `inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs-unstable"` do?
#    → Makes home-manager use OUR nixpkgs instead of fetching its own
#
# 3. What does `outputs = inputs@{ self, darwin, nixpkgs-unstable, home-manager, ... }:` mean?
#    → outputs is a function. inputs@ binds the whole set. Destructuring extracts named inputs.
#
# 4. What does `specialArgs = { inherit inputs; }` do?
#    → Passes the `inputs` attrset to all modules as an extra argument
#
# 5. Why is `import ./home/mbp2023.nix` used instead of just `./home/mbp2023.nix`?
#    → `import` evaluates the file and returns the function inside it.
#      The module system then calls that function with { pkgs, config, ... }.

# ── Exercise 2: Minimal flake ───────────────────────────────────────────
#
# TODO: Create a directory `minimal-flake/` next to this file with this flake.nix:
#
# {
#   description = "My first flake";
#
#   inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
#
#   outputs = { self, nixpkgs }:
#     let
#       system = "aarch64-darwin";  # or x86_64-linux
#       pkgs = nixpkgs.legacyPackages.${system};
#     in {
#       packages.${system}.default = pkgs.hello;
#
#       devShells.${system}.default = pkgs.mkShell {
#         packages = [ pkgs.cowsay pkgs.fortune ];
#       };
#     };
# }
#
# Then try:
#   cd training/06-flakes/exercises/minimal-flake
#   nix build          # builds hello
#   ./result/bin/hello
#   nix develop        # enters shell with cowsay + fortune
#   cowsay "I made a flake!"

# ── Exercise 3: Understanding self ──────────────────────────────────────
#
# In nix repl, load your flake:
#   nix repl
#   :lf .
#
# Then try:
#   self.sourceInfo
#   self.outPath
#   self ? rev          # true only if git tree is clean
#   self.lastModified
#
# Q: What is self.outPath? Where does it point?
# A: It's the store path containing a copy of your flake source.

# Placeholder so this file is valid nix:
"Annotation exercise — see comments above"
