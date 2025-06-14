{ pkgs, config, lib, inputs, ... }:
{
  environment.systemPackages = [
    pkgs.vim # text editor
    pkgs.libnotify # notification daemon
    pkgs.home-manager # Home Manager for user configuration
    pkgs.flameshot # screenshot utility
    pkgs.cheese # webcam utility
    pkgs.vlc # media player
    pkgs.feh # image viewer
    pkgs.smile # emoji picker
    pkgs.appimage-run
    # set when darwin gets updated, and ghostty is no more marked as broken
    #pkgs.ghostty
  ];
}
