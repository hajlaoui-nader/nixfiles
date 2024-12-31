{ pkgs, ... }:
{
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.home-manager
      pkgs.ghostty
    ];

}
