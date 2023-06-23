{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    ./modules/zsh
    ./modules/fish.nix
    ./modules/git.nix
  ];

  home.homeDirectory = "/Users/naderh";
  home.username = "naderh";

  programs.htop.enable = true;  
  
  home.stateVersion = "20.09";

  home.packages = with pkgs; [
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/data/fonts/nerdfonts/default.nix
    # nerdfonts
    bitwarden-cli
    fishPlugins.done
    fishPlugins.fzf-fish
    fishPlugins.forgit
    fishPlugins.hydro
    fishPlugins.grc
    grc
  ];

}
