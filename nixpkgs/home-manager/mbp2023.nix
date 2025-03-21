{ pkgs, unstable, ... }:

{
  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    ./modules/zsh
    #./modules/fish.nix
    ./modules/git.nix
    ./programs/tmux
    ./programs/ghostty

  ];

  home.homeDirectory = "/Users/naderh";
  home.username = "naderh";

  programs.htop.enable = true;

  home.stateVersion = "23.05";

  home.packages = with unstable; [
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
