{ config, pkgs, inputs, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  nix.settings.trusted-users = [ "zeus" ];

  nix.registry.nixpkgs.flake = inputs.nixpkgs-24_11;

}
