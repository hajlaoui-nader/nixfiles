{ inputs, config, pkgs, lib, ... }: {

  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs;
    [
      zip # archives
      unzip # archives
      lsd
      docker
      jq
      docker-compose # docker manager
      neofetch # command-line system information
      ripgrep # fast grep
      tree # display files in a tree view
      eza # a better `ls`
      bottom # a better `top`
      tree-sitter # syntax highlighting
      fd # a better `find`
      lf # a file manager
      nmap
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
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  home.shellAliases = {
    lsd = "eza --long --header --git --all";
    dps = "docker ps";
    zshreload = "source ~/.zshrc";
    zshrc = "nvim ~/.zshrc";
    c = "clear"; 
    # git
    gs = "git status";
    gd = "git diff";
    gc = "git commit -v";

    # v
    v = "nvim"; 
  };

  programs = {
    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "DarkNeon";
      };
    };
    
    btop.enable = true;
    eza.enable = true;
    
    jq.enable = true;
    ssh.enable = true;

  };

  imports = [ ./fzf.nix ./nvim/nvim.nix];

}
