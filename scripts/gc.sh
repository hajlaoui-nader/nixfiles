#!/bin/sh
set -e

echo "=== Before ==="
df -h / | tail -1

echo ""
echo "=== Deleting old generations ==="
sudo nix-env --delete-generations old --profile /nix/var/nix/profiles/system
nix-env --delete-generations old --profile ~/.local/state/nix/profiles/home-manager

echo ""
echo "=== Running garbage collection ==="
nix-store --gc

echo ""
echo "=== After ==="
df -h / | tail -1
