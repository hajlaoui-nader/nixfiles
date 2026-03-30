#!/usr/bin/env bash
# Exercise 01: Inspect a Derivation
#
# Run: bash training/02-derivations/exercises/e01-inspect-derivation.sh
#
# This exercise walks you through inspecting real derivations.

set -euo pipefail

echo "═══ Exercise 1: Show a derivation ═══"
echo ""
echo "Running: nix derivation show nixpkgs#hello"
echo "This shows the .drv file contents as JSON."
echo ""
nix derivation show nixpkgs#hello 2>/dev/null | head -40
echo "..."
echo ""

echo "═══ Exercise 2: Find the output path ═══"
echo ""
echo "The output path is where the built package will live:"
nix eval --raw nixpkgs#hello.outPath 2>/dev/null
echo ""
echo ""

echo "═══ Exercise 3: Find the .drv path ═══"
echo ""
echo "The .drv path is where the build plan lives:"
nix eval --raw nixpkgs#hello.drvPath 2>/dev/null
echo ""
echo ""

echo "═══ Exercise 4: Compare hashes ═══"
echo ""
echo "hello and cowsay have different hashes because they have different inputs:"
echo ""
echo "hello .drv:"
nix eval --raw nixpkgs#hello.drvPath 2>/dev/null
echo ""
echo ""
echo "cowsay .drv:"
nix eval --raw nixpkgs#cowsay.drvPath 2>/dev/null
echo ""
echo ""
echo "Notice: different inputs → different hashes → different store paths"
echo ""

echo "═══ Exercise 5: Count input derivations ═══"
echo ""
echo "How many build-time dependencies does hello have?"
echo ""
COUNT=$(nix derivation show nixpkgs#hello 2>/dev/null | python3 -c "
import json, sys
data = json.load(sys.stdin)
for drv in data.values():
    print(len(drv.get('inputDrvs', {})))
" 2>/dev/null || echo "python3 not available, try: nix derivation show nixpkgs#hello | jq '.[].inputDrvs | length'")
echo "Input derivation count: $COUNT"
echo ""

echo "═══ TODO: Your turn! ═══"
echo ""
echo "1. Run: nix derivation show nixpkgs#ripgrep 2>/dev/null | head -60"
echo "   Q: What is the builder? What system is it built for?"
echo ""
echo "2. Run: nix eval --raw nixpkgs#git.outPath"
echo "   Q: What is the hash prefix of git's store path?"
echo ""
echo "3. Compare: nix eval --raw nixpkgs#bash.outPath"
echo "   vs:      nix eval --raw nixpkgs#bashInteractive.outPath"
echo "   Q: Are they the same? Why or why not?"
