#bin/sh
set -e

sudo nix build .#darwinConfigurations.mbp2023.system && sudo ./result/sw/bin/darwin-rebuild switch --flake .#mbp2023
