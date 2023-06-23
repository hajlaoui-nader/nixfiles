{ config, pkgs, libs, ... }:
{
    programs.fish = {
        enable = true;
        shellAliases = {
            lsd = "exa --long --header --git --all";
            dps = "docker-compose ps";
            zshreload = "source ~/.zshrc";
            zshrc = "nvim ~/.zshrc";
            c = "clear"; 
            # git
            gs = "git status";
            gd = "git diff";
            gc = "git commit -v";
        };
    };
}