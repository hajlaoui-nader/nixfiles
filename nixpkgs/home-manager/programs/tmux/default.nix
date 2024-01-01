{ lib, pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    terminal = "screen-256color";
    keyMode = "vi";
    shortcut = "a";
  };
}
