#!/usr/bin/env bash
# Exercise 03: Rebuild Internals
#
# Run: bash training/07-advanced/exercises/e03-rebuild-internals.sh
#
# Explore what darwin-rebuild/nixos-rebuild actually does.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/../../.." && pwd)"

echo "═══ Exercise 1: Explore in nix repl ═══"
echo ""
echo "TODO: Open a nix repl and load your flake:"
echo ""
echo "  cd $REPO_ROOT"
echo "  nix repl"
echo "  :lf ."
echo ""
echo "Then explore your darwin configuration:"
echo ""
echo "  # The system derivation:"
echo "  darwinConfigurations.mbp2023.system"
echo ""
echo "  # All system packages:"
echo "  darwinConfigurations.mbp2023.config.environment.systemPackages"
echo ""
echo "  # Home manager user config:"
echo "  darwinConfigurations.mbp2023.config.home-manager.users.naderh.home.homeDirectory"
echo ""
echo "  # Git config:"
echo "  darwinConfigurations.mbp2023.config.home-manager.users.naderh.programs.git.enable"
echo ""
echo "  # The overlays applied:"
echo "  darwinConfigurations.mbp2023.config.nixpkgs.overlays"
echo ""

echo "═══ Exercise 2: Current system profile ═══"
echo ""
echo "Your current system profile (nix-darwin):"
echo ""
if [ -L /run/current-system ]; then
  echo "  /run/current-system -> $(readlink /run/current-system)"
  echo ""
  echo "  Contents:"
  ls /run/current-system/ 2>/dev/null | sed 's/^/    /'
else
  echo "  /run/current-system not found (might be a NixOS-only path)"
  echo ""
  echo "  Looking for darwin system profile..."
  if [ -L /nix/var/nix/profiles/system ]; then
    echo "  /nix/var/nix/profiles/system -> $(readlink /nix/var/nix/profiles/system)"
  fi
fi
echo ""

echo "═══ Exercise 3: Profile generations ═══"
echo ""
echo "System profile generations:"
echo ""
if ls /nix/var/nix/profiles/system-*-link 2>/dev/null | tail -5; then
  echo ""
  echo "  Each generation is a GC root pointing to a different system derivation."
  echo "  Rolling back switches to the previous generation's activation script."
else
  echo "  (no system generations found — check darwin-rebuild --list-generations)"
fi
echo ""

echo "═══ Exercise 4: The activation script ═══"
echo ""
echo "TODO: Read the activation script of your current system:"
echo ""
if [ -L /run/current-system ]; then
  echo "  cat /run/current-system/activate | head -50"
  echo ""
  echo "  First 20 lines:"
  head -20 /run/current-system/activate 2>/dev/null | sed 's/^/    /'
else
  echo "  Build your system first:"
  echo "  nix build .#darwinConfigurations.mbp2023.system"
  echo "  cat result/activate | head -50"
fi
echo ""

echo "═══ Exercise 5: What changed? ═══"
echo ""
echo "TODO: To see what would change between your current system and a new build:"
echo ""
echo "  # Build (don't switch):"
echo "  nix build .#darwinConfigurations.mbp2023.system"
echo ""
echo "  # Compare store paths:"
echo "  nix store diff-closures /run/current-system ./result"
echo ""
echo "  This shows which packages were added, removed, or updated."
echo ""

echo "═══ Exercise 6: Trace the full rebuild pipeline ═══"
echo ""
echo "The full pipeline when you run ./scripts/darwin.sh:"
echo ""
echo "  1. nix build .#darwinConfigurations.mbp2023.system"
echo "     → Evaluates flake.nix → builds toplevel derivation"
echo ""
echo "  2. sudo ./result/sw/bin/darwin-rebuild switch --flake .#mbp2023"
echo "     → Runs the activation script"
echo "     → Creates a new profile generation"
echo "     → Links /run/current-system to the new build"
echo ""
echo "  3. Profile: /nix/var/nix/profiles/system → new generation"
echo "     → Old generation kept as GC root until garbage collected"
echo ""
echo "To roll back:"
echo "  sudo darwin-rebuild switch --rollback"
echo "  → Reactivates the previous generation's configuration"
