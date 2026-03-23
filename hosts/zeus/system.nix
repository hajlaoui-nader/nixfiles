{ config, pkgs, inputs, ... }:
{
  imports = [
    ./configuration.nix
    ./hardware-configuration.nix
    ../../modules/system/desktop-environments/hyprland.nix  # Enable Hyprland
  ];

  nix.settings = {
    trusted-users = [ "zeus" ];
    substituters = [
      "https://cache.garnix.io"
    ];
    trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

}
