#!/usr/bin/env bash
# Exercise 01: Store Paths and Hashing
#
# Run: bash training/03-store/exercises/e01-store-paths.sh
#
# Explore how store paths are computed and what changes them.

set -euo pipefail

echo "═══ Exercise 1: Inspect a store path ═══"
echo ""
HELLO_PATH=$(nix eval --raw nixpkgs#hello.outPath 2>/dev/null)
echo "hello lives at: $HELLO_PATH"
echo ""
echo "Path format: /nix/store/<32-char-hash>-<name>"
echo "The hash encodes ALL inputs to the derivation."
echo ""

echo "═══ Exercise 2: Name change → different hash ═══"
echo ""
echo "Original hello path:"
echo "  $HELLO_PATH"
echo ""
echo "TODO: Run this in nix repl to see what happens when you change the name:"
echo '  :lf nixpkgs'
echo '  (packages.${builtins.currentSystem}.hello.overrideAttrs { pname = "hola"; }).outPath'
echo ""
echo "Q: Is the hash different? Why?"
echo "A: Yes — the name is part of the hash inputs, so any change produces a different path."
echo ""

echo "═══ Exercise 3: Same content, different path ═══"
echo ""
echo "These two derivations produce identical output but have different store paths:"
echo ""
A_PATH=$(nix eval --raw --expr '
  (derivation {
    name = "same-content-a";
    system = builtins.currentSystem;
    builder = "/bin/sh";
    args = [ "-c" "echo hello > \$out" ];
  }).outPath
' 2>/dev/null)
B_PATH=$(nix eval --raw --expr '
  (derivation {
    name = "same-content-b";
    system = builtins.currentSystem;
    builder = "/bin/sh";
    args = [ "-c" "echo hello > \$out" ];
  }).outPath
' 2>/dev/null)
echo "  A: $A_PATH"
echo "  B: $B_PATH"
echo ""
echo "Different names → different hashes, even though both write 'hello'."
echo "This is input-addressed hashing: the hash depends on inputs (including name), not output."
echo ""

echo "═══ Exercise 4: Fixed-output derivation ═══"
echo ""
echo "TODO: Run in nix repl:"
echo '  builtins.fetchurl "https://example.com"'
echo ""
echo "This is a fixed-output derivation. The store path is determined by the"
echo "content hash, not the URL. Two different URLs producing the same content"
echo "would have the same store path."
echo ""

echo "═══ TODO: Your turn! ═══"
echo ""
echo "1. Pick two packages (e.g., ripgrep and fd) and compare their .drv paths."
echo "   Command: nix eval --raw nixpkgs#ripgrep.drvPath"
echo ""
echo "2. Use 'nix derivation show nixpkgs#ripgrep' to find its builder."
echo "   Is it bash? Something else?"
echo ""
echo "3. Try: nix eval --raw --expr '(import <nixpkgs> {}).hello.outPath'"
echo "   vs:  nix eval --raw nixpkgs#hello.outPath"
echo "   Are they the same? (They should be if both resolve to the same nixpkgs commit.)"
