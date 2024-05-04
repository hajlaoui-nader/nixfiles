#bin/sh
set -e

nix build .#darwinConfigurations.mbp2023.system && ./result/sw/bin/darwin-rebuild switch --flake .#mbp2023
