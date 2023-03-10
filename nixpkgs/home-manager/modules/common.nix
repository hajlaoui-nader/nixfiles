{ inputs, config, pkgs, pkgsUnstable, lib, ... }: {

  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs;
    [
      # archives
      zip
      unzip
      lsd
      docker
      jq
      docker-compose # docker manager
      neofetch # command-line system information
      ripgrep # fast grep
      tree # display files in a tree view
      exa # a better `ls`
      bottom # a better `top`
      tree-sitter # syntax highlighting
      fd # a better `find`
    ] ++ lib.optionals stdenv.isDarwin [
      coreutils # provides `dd` with --status=progress
      wifi-password
    ] ++ lib.optionals stdenv.isLinux [
      iputils # provides `ping`, `ifconfig`, ...
      libuuid # `uuidgen` (already pre-installed on mac)
      font-awesome # awesome fonts
      material-design-icons # fonts with glyphs
    ];

  home.sessionVariables = {
    DISPLAY = ":0";
    EDITOR = "nvim";
  };

  programs = {
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "Catppuccin-mocha";
      };
      themes = {
        Catppuccin-mocha = builtins.readFile (pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "00bd462e8fab5f74490335dcf881ebe7784d23fa";
            sha256 = "yzn+1IXxQaKcCK7fBdjtVohns0kbN+gcqbWVE4Bx7G8=";
          }
          + "/Catppuccin-mocha.tmTheme");
      };
    };
    btop.enable = true;
    exa.enable = true;
    
    jq.enable = true;
    ssh.enable = true;

  };

  imports = [ ./fzf.nix ./nvim/nvim.nix ];

}
