#!/usr/bin/env bash
# Exercise 02: Inputs and Locking
#
# Run: bash training/06-flakes/exercises/e02-inputs-locking.sh
#
# Explore flake.lock and input management.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"

echo "═══ Exercise 1: Inspect flake.lock ═══"
echo ""
echo "Your flake.lock pins these inputs:"
echo ""
if command -v jq &>/dev/null; then
  jq -r '.nodes | to_entries[] | select(.key != "root") | "  \(.key): \(.value.locked.rev // .value.locked.narHash // "n/a" | .[0:16])..."' "$REPO_ROOT/flake.lock"
else
  echo "  (install jq to see parsed output, or read flake.lock directly)"
fi
echo ""

echo "═══ Exercise 2: Trace a follows ═══"
echo ""
echo "In your flake.lock, home-manager's nixpkgs input 'follows' your nixpkgs-unstable."
echo "This means they share the same nixpkgs commit."
echo ""
if command -v jq &>/dev/null; then
  echo "home-manager's nixpkgs follows:"
  jq -r '.nodes["home-manager"].inputs.nixpkgs // ["(direct)"]' "$REPO_ROOT/flake.lock"
  echo ""
  echo "darwin's nixpkgs follows:"
  jq -r '.nodes["darwin"].inputs.nixpkgs // ["(direct)"]' "$REPO_ROOT/flake.lock"
fi
echo ""

echo "═══ Exercise 3: Flake metadata ═══"
echo ""
echo "Running: nix flake metadata (from repo root)"
echo ""
(cd "$REPO_ROOT" && nix flake metadata 2>/dev/null) || echo "(run from repo root)"
echo ""

echo "═══ Exercise 4: What would update change? ═══"
echo ""
echo "To see what nix flake update would change WITHOUT actually updating:"
echo "  cd $REPO_ROOT"
echo "  nix flake update --dry-run"
echo ""
echo "To update just one input:"
echo "  nix flake lock --update-input home-manager"
echo ""

echo "═══ TODO: Your turn! ═══"
echo ""
echo "1. Open $REPO_ROOT/flake.lock and find the exact nixpkgs-unstable commit."
echo "   Verify it matches the rev in flake.nix."
echo ""
echo "2. Try removing the 'follows' from home-manager in flake.nix:"
echo "   (DON'T commit — just experiment)"
echo "   Run: nix flake lock --dry-run"
echo "   Q: Does home-manager now want to fetch its own nixpkgs?"
echo ""
echo "3. What happens if flake.lock is deleted?"
echo "   (DON'T actually delete it — just know the answer)"
echo "   A: Nix re-fetches all inputs and creates a fresh lock file."
echo "   This might change versions if using branch refs instead of commit pins."
