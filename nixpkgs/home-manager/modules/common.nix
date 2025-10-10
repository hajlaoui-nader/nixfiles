{ inputs, config, pkgs, unstable, lib, ... }:
let
  snippetFiles =
    {
      "global.json" = ./nvim/snippets/global.json;
      "python.json" = ./nvim/snippets/python.json;
      "go.json" = ./nvim/snippets/go.json;
    };
in
{

  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # Suppress SSH default config warning
  programs.ssh.enableDefaultConfig = false;

  home.packages = [
    pkgs.man-pages # linux programmer's manual
    pkgs.zip # archives
    pkgs.unzip # archives
    pkgs.lsd
    pkgs.docker
    pkgs.jq
    pkgs.docker-compose # docker manager
    pkgs.neofetch # command-line system information
    pkgs.ripgrep # fast grep
    pkgs.tree # display files in a tree view
    pkgs.eza # a better `ls`
    pkgs.bottom # a better `top`
    pkgs.tree-sitter # syntax highlighting
    pkgs.fd # a better `find`
    #lf # a file manager
    pkgs.file # file type
    pkgs.xxd # hexdump
    pkgs.nmap # network scanner
    pkgs.duf # disk usage
    pkgs.lua-language-server
    pkgs.lua
    pkgs.go
    pkgs.gcc14
    pkgs.gdb
    pkgs.cargo
    pkgs.rustc
    pkgs.inetutils # provides `ftp`, `telnet`, ...
    pkgs.dig # DNS lookup
    pkgs.openresolv # DNS resolver
    # unstable.claude-code # temporarily disabled due to hash mismatch
  ] ++ lib.optionals pkgs.stdenv.isDarwin [
    pkgs.coreutils # provides `dd` with --status=progress
    pkgs.wifi-password
  ] ++ lib.optionals pkgs.stdenv.isLinux [
    pkgs.iputils # provides `ping`, `ifconfig`, ...
    pkgs.libuuid # `uuidgen` (already pre-installed on mac)
    pkgs.font-awesome # awesome fonts
    pkgs.material-design-icons # fonts with glyphs
    pkgs.vscode
  ];

  home.sessionVariables = {
    DISPLAY = ":0";
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "ghostty";
  };

  home.shellAliases = {
    lsd = "eza --long --header --git --all";
    dps = "docker ps --all";
    stopanddeleteallcontainers = "docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)";
    deleteallvolumes = "docker volume rm $(docker volume ls -q)";
    zshreload = "source ~/.zshrc";
    zshrc = "nvim ~/.zshrc";
    c = "clear";
    # git
    gs = "git status";
    gd = "git diff";
    gc = "git commit -v";

    # v
    v = "nvim";
    installedpackages = "nix-store --query --requisites /run/current-system";
    installedpackagespretty = "nix-store --query --requisites /run/current-system | cut -d- -f2- | sort | uniq";
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

  home.file = builtins.foldl'
    (acc: key:
      acc // {
        ".config/nvim/snippets/${key}" = {
          source = builtins.toPath snippetFiles.${key};
          recursive = true;
        };
      }
    )
    { }
    (builtins.attrNames snippetFiles);


  imports = [ ./fzf.nix ./nvim/nvim.nix ];
}
