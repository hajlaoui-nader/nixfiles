#!/usr/bin/env bash
# Exercise 01: Explore nixpkgs
#
# Run: bash training/04-nixpkgs/exercises/e01-explore-nixpkgs.sh
#
# Explore the nixpkgs package set structure.

set -euo pipefail

echo "═══ Exercise 1: Find a package's source ═══"
echo ""
echo "Where is ripgrep defined in nixpkgs?"
echo ""
echo "Running: nix eval nixpkgs#ripgrep.meta.position"
nix eval nixpkgs#ripgrep.meta.position 2>/dev/null || echo "(evaluate in nix repl instead)"
echo ""

echo "═══ Exercise 2: Package metadata ═══"
echo ""
echo "Inspect a package's metadata:"
echo ""
echo "description:"
nix eval nixpkgs#ripgrep.meta.description 2>/dev/null || true
echo ""
echo "homepage:"
nix eval nixpkgs#ripgrep.meta.homepage 2>/dev/null || true
echo ""
echo "license:"
nix eval --json nixpkgs#ripgrep.meta.license.spdxId 2>/dev/null || true
echo ""

echo "═══ Exercise 3: Count packages ═══"
echo ""
echo "How many top-level attributes does nixpkgs have?"
echo ""
echo "Running: nix eval --expr 'builtins.length (builtins.attrNames (import <nixpkgs> {}))'"
echo "(This takes a moment...)"
COUNT=$(nix eval --expr 'builtins.length (builtins.attrNames (import <nixpkgs> {}))' 2>/dev/null || echo "?")
echo "Count: $COUNT"
echo ""
echo "Not all of these are packages — some are functions, lib, etc."
echo ""

echo "═══ Exercise 4: Explore in nix repl ═══"
echo ""
echo "TODO: Open a nix repl and try these commands:"
echo ""
echo "  nix repl"
echo "  > pkgs = import <nixpkgs> {}"
echo ""
echo "  # Find where git is defined:"
echo "  > pkgs.git.meta.position"
echo ""
echo "  # See git's build inputs:"
echo "  > pkgs.git.buildInputs"
echo ""
echo "  # Check if a package exists:"
echo "  > pkgs ? ripgrep"
echo ""
echo "  # See what lib provides:"
echo "  > builtins.attrNames pkgs.lib"
echo ""
echo "  # Try lib functions:"
echo "  > pkgs.lib.strings.toUpper \"hello\""
echo "  > pkgs.lib.lists.unique [ 1 2 2 3 3 3 ]"
echo "  > pkgs.lib.attrsets.filterAttrs (n: v: v > 2) { a = 1; b = 3; c = 5; }"
