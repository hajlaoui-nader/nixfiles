{ pkgs, ... }:

{
  imports = [
    ../modules/home/home-manager.nix
    ../modules/home/common.nix
    ../modules/home/zsh
    #../modules/home/fish.nix
    ../modules/home/git.nix
    ../modules/home/tmux
    ../modules/home/ghostty

  ];

  home.homeDirectory = "/Users/naderh";
  home.username = "naderh";

  programs.htop.enable = true;

  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerdfonts/default.nix
    # nerdfonts
    #bitwarden-cli # it causes an error
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

}
