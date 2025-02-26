{ config, pkgs, lib, libs, ... }:
{
  programs.git = {
    enable = true;
    userName = "Nader Hajlaoui";
    userEmail = "nader@echo-analytics.io";

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
      github.user = "include-nader-h";

      push.autoSetupRemote = true;
      push.followTags = true; # push tags when pushing branches

      core.editor = "nvim";
      core.fileMode = false;
      core.ignorecase = false;
      column.ui = "auto";
      branch.sort = "-committerdate"; # sort branches by last commit date
      tag.sort = "version:refname"; # sort tags by version number
      diff.algorithm = "histogram";
      diff.colorMoved = "plain"; # don't color moved lines
      diff.mnemonicprefix = true; # use mnemonic prefixes in diffs 
      diff.renames = true; # detect renames
      # fetch 
      fetch.prune = true; # prune deleted branches 
      fetch.pruneTags = true; # prune deleted tags 
      fetch.all = true; # fetch all branches
      # commit 
      commit.verbose = true; # show diff in commit message
    };
  };
}