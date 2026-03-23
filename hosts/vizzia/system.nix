{ config, pkgs, inputs, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  nix.settings.trusted-users = [ "nader" ];

  nix.registry.nixpkgs.flake = inputs.nixpkgs-stable;

}

