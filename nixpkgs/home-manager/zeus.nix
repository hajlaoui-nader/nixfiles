{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    ./modules/zsh
    ./modules/git.nix
    ./programs/hyprland
    ./programs/alacritty.nix
    ./programs/rofi
    ./programs/waybar
    ./programs/kitty.nix
    ./programs/tmux
    ./themes
  ];

  home.stateVersion = "23.11";

  home.username = "zeus";
  home.homeDirectory = "/home/zeus";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    home-manager
    networkmanagerapplet
    spotify
    #nerdfonts
    iosevka
    copyq
    bitwarden-cli
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "JetBrainsMono"
        "SourceCodePro"
      ];
    })
  ];

}
