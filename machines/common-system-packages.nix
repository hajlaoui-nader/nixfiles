{ pkgs, config, lib, inputs, ... }:
{
  environment.systemPackages = [
    pkgs.vim
    pkgs.home-manager
    pkgs.flameshot
    # set when darwin gets updated, and ghostty is no more marked as broken
    #pkgs.ghostty
  ];

  # Configure registry to match flake inputs
  nix.registry = lib.mapAttrs (name: flake: { inherit flake; }) inputs;

  # Set nix path to match inputs
  nix.nixPath = lib.mapAttrsToList (name: value: "${name}=${value}") inputs;

  nix.channel.enable = false;
}
