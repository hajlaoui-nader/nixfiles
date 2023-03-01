{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    ./modules/git.nix
  ];

  home.stateVersion = "20.09";

  home.username = "nhajlaoui";
  home.homeDirectory = "/home/nhajlaoui";

  home.packages = with pkgs; [
  ];

}
