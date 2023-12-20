{ config, lib, pkgs, ... }:
let
  gnomePkgs = with pkgs.gnome; [
    eog      # image viewer
    evince   # pdf reader
    gnome-disk-utility
    nautilus # file manager

    # file manager overlay
    #pkgs.nautilus-gtk3
    #pkgs.nautilus-bin
    #pkgs.nautilus-patched
  ];
in  
{
  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    ./modules/zsh
    ./modules/git.nix
    #./modules/theme
    ./services/dunst
    ./programs/xmonad
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
  ] ++ gnomePkgs;

}
