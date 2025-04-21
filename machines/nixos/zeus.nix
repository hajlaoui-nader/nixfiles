{ config, pkgs, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
  ];

  nix.settings.trusted-users = [ "zeus" ];
}
