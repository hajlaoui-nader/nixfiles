{ pkgs, config, machine, ... }:
{

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.zsh = {
    enable = true;
    enableSyntaxHighlighting = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" ];
    };

    plugins = [
      {
        name = "fzf-tab";
        src = pkgs.fetchFromGitHub {
          owner = "Aloxaf";
          repo = "fzf-tab";
          rev = "7e0eee64df6c7c81a57792674646b5feaf89f263";
          sha256 = "sha256-ixUnuNtxxmiigeVjzuV5uG6rIBPY/1vdBZF2/Qv0Trs=";
        };
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "af6f8a266ea1875b9a3e86e14796cadbe1cfbf08";
          sha256 = "sha256-BjgMhILEL/qdgfno4LR64LSB8n9pC9R+gG7IQWwgyfQ=";
        };
      }
    ];

    localVariables = {
      POWERLEVEL9K_MODE = "awesome-patched";
      HYPHEN_INSENSITIVE = "true";
      COMPLETION_WAITING_DOTS = "true";
      ZSH_HIGHLIGHT_MAXLENGTH = "20";
      JK_MACHINE_NAME = "nh-shell";
    };

    shellAliases = {
      lsd = "exa --long --header --git --all";
      dps = "docker-compose ps";
    };

    initExtraBeforeCompInit = ''
      # powerlevel10k
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ${./p10k.zsh}
    '';

    history = {
      size = 100000;
    };

  };

}
