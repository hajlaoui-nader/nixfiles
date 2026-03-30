#!/usr/bin/env bash
# Exercise 02: References and Closures
#
# Run: bash training/03-store/exercises/e02-closures.sh
#
# Explore runtime references and closure sizes.

set -euo pipefail

echo "═══ Exercise 1: Runtime references ═══"
echo ""
echo "What does hello need at runtime?"
echo ""
echo "Running: nix path-info -r nixpkgs#hello"
nix path-info -r nixpkgs#hello 2>/dev/null
echo ""

echo "═══ Exercise 2: Closure sizes ═══"
echo ""
echo "Compare closure sizes of different packages:"
echo "(NAR size = package itself, Closure size = package + all deps)"
echo ""
echo "hello:"
nix path-info -sSh nixpkgs#hello 2>/dev/null || echo "  (build first with: nix build nixpkgs#hello)"
echo ""
echo "ripgrep:"
nix path-info -sSh nixpkgs#ripgrep 2>/dev/null || echo "  (build first with: nix build nixpkgs#ripgrep)"
echo ""
echo "git:"
nix path-info -sSh nixpkgs#git 2>/dev/null || echo "  (build first with: nix build nixpkgs#git)"
echo ""

echo "═══ Exercise 3: Full closure listing ═══"
echo ""
echo "Every store path in hello's closure, with sizes:"
echo ""
nix path-info -rsSh nixpkgs#hello 2>/dev/null | head -20
echo "..."
echo ""

echo "═══ Exercise 4: Why does a dependency exist? ═══"
echo ""
echo "TODO: Pick a package and investigate an unexpected dependency."
echo ""
echo "Commands to try:"
echo "  nix why-depends nixpkgs#hello nixpkgs#glibc"
echo "  nix why-depends nixpkgs#git nixpkgs#perl"
echo ""
echo "The output shows the exact file and byte offset where the reference appears."
echo ""

echo "═══ TODO: Your turn! ═══"
echo ""
echo "1. Compare the closure sizes of pkgs.python3 vs pkgs.python3Minimal"
echo "   Command: nix path-info -sSh nixpkgs#python3"
echo "   Command: nix path-info -sSh nixpkgs#python3Minimal"
echo "   Q: How much smaller is the minimal variant?"
echo ""
echo "2. Find out why git depends on perl:"
echo "   Command: nix why-depends nixpkgs#git nixpkgs#perl"
echo ""
echo "3. Count the total number of store paths in git's closure:"
echo "   Command: nix path-info -r nixpkgs#git | wc -l"
