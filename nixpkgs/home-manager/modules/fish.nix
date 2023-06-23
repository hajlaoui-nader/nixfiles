{ config, pkgs, libs, ... }:
{
    programs.fish = {
        enable = true;
        shellAliases = {};
        interactiveShellInit = ''
            set fish_greeting # Disable greeting
        '';
    };
}