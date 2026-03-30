#!/usr/bin/env bash
# Exercise 03: Garbage Collection
#
# Run: bash training/03-store/exercises/e03-gc.sh
#
# Explore GC roots and garbage collection.
# NOTE: This exercise only READS — it won't delete anything without confirmation.

set -euo pipefail

echo "═══ Exercise 1: List GC roots ═══"
echo ""
echo "These are the symlinks that prevent store paths from being collected:"
echo ""
nix-store --gc --print-roots 2>/dev/null | head -20
echo "..."
echo ""
echo "Each line shows: <root symlink> -> <store path>"
echo ""

echo "═══ Exercise 2: Find result symlinks ═══"
echo ""
echo "Looking for 'result' symlinks (created by nix build) in common locations:"
echo ""
# Check home directory and common project dirs
for dir in "$HOME" "$HOME/projects" "$(pwd)"; do
  if [ -d "$dir" ]; then
    found=$(find "$dir" -maxdepth 3 -name "result" -type l 2>/dev/null | head -5)
    if [ -n "$found" ]; then
      echo "In $dir:"
      echo "$found" | while read -r link; do
        target=$(readlink "$link" 2>/dev/null || echo "broken")
        echo "  $link -> $target"
      done
    fi
  fi
done
echo ""

echo "═══ Exercise 3: Check store size ═══"
echo ""
echo "Current store size:"
du -sh /nix/store 2>/dev/null || echo "  (cannot read /nix/store size)"
echo ""

echo "═══ Exercise 4: Dry-run garbage collection ═══"
echo ""
echo "What WOULD be deleted? (dry run — nothing is actually deleted)"
echo ""
echo "Running: nix store gc --dry-run 2>&1 | tail -5"
nix store gc --dry-run 2>&1 | tail -5
echo ""

echo "═══ TODO: Your turn! ═══"
echo ""
echo "1. Build something and observe the result symlink:"
echo "   nix build nixpkgs#cowsay"
echo "   ls -la result"
echo "   nix-store --gc --print-roots | grep result"
echo ""
echo "2. Delete the result symlink and check if the path is now collectible:"
echo "   rm result"
echo "   nix store gc --dry-run 2>&1 | grep cowsay"
echo ""
echo "3. List your home-manager generations:"
echo "   home-manager generations"
echo "   Q: How many generations do you have? Each one is a GC root."
echo ""
echo "4. Check how much space you could reclaim:"
echo "   nix store gc --dry-run 2>&1 | tail -1"
