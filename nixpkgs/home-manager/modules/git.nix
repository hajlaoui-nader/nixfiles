{ config, pkgs, lib, libs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Nader Hajlaoui";
    userEmail = "hajlaoui.nader@gmail.com";

    delta = {
      enable = true;
      options = {
        #syntax-theme = "solarized-dark";
        side-by-side = true;
      };
    };

    # TODO there's a problem here, all aliases defined below don't appear
    aliases = { };

    ignores = [
      "**/.metals/"
      "**/project/metals.sbt"
      "**/.idea/"
      "**/.vscode/settings.json"
      "**/.bloop/"
      "**/.bsp/"
      "**/.scala-build/"
      "**/.direnv/"
      "**/.DS_Store"
    ];

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
