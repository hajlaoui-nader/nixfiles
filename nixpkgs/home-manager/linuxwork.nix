{ config, lib, pkgs, ... }:

{
  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    # TODO uncomment
    # ./modules/zsh
    # TODO uncomment
    # ./modules/git.nix
  ];

  home.stateVersion = "20.09";

  home.username = "nhajlaoui";
  home.homeDirectory = "/home/nhajlaoui";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode"
          "FiraMono"
          "JetBrainsMono"
          "SourceCodePro" ]; })
  ];

}
