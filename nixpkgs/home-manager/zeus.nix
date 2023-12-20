{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    ./modules/zsh
    ./modules/git.nix
    ./programs/alacritty.nix
  ];

  home.stateVersion = "23.11";

  home.username = "zeus";
  home.homeDirectory = "/home/zeus";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    #nerdfonts
    bitwarden-cli
    (nerdfonts.override { fonts = [ "FiraCode"
          "FiraMono"
          "JetBrainsMono"
          "SourceCodePro" ]; })
  ];

}
