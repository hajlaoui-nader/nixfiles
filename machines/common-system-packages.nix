{ pkgs, ... }:
{
  environment.systemPackages =
    [
      pkgs.vim
      pkgs.home-manager
      # set when darwin gets updated, and ghostty is no more marked as broken
      #pkgs.ghostty
    ];

  security.pam.services.sudo_local.touchIdAuth = true;
}
