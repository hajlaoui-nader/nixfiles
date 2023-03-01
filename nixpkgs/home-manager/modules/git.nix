{ config, pkgs, lib, libs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Nader Hajlaoui";
    userEmail = "hajlaoui.nader@gmail.com";

    delta = {
      enable = true;
      options = {
        syntax-theme = "solarized-dark";
        side-by-side = true;
      };
    };

  aliases = {
      gs = "git status";
      gls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate";
      gll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\\\ %Creset%s%Cblue\\\\ [%cn]\" --decorate --numstat";
    };

    extraConfig = {
      pull.rebase = true;
      init.defaultBranch = "main";
      github.user = "hajlaoui-nader";

      push.autoSetupRemote = true;

      core.editor = "nvim";
      core.fileMode = false;
      core.ignorecase = false;
    };
  };
}
