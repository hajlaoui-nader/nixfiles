{ lib, pkgs, ... }:
let
  #plugins = pkgs.tmuxPlugins // pkgs.callPackage ./custom-plugins.nix { };
  tmuxConf = lib.readFile ./default.conf;
in
{
  programs.tmux = {
    enable = true;
    aggressiveResize = true;
    baseIndex = 1;
    terminal = "screen-256color";
    keyMode = "vi";
    escapeTime = 0;
    shortcut = "a";

    extraConfig = tmuxConf;
    plugins = with pkgs.tmuxPlugins; [
      cpu
      nord # theme
      {
        plugin = resurrect;
        extraConfig = "set -g @resurrect-strategy-nvim 'session'";
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g @continuum-restore 'on'
          set -g @continuum-save-interval '60' # minutes
        '';
      }
    ];
  };
}
