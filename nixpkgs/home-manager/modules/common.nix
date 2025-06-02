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

  home.packages = with pkgs;
    [
      man-pages # linux programmer's manual
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
      #lf # a file manager
      file # file type
      xxd # hexdump
      nmap
      duf # disk usage
      lua-language-server
      lua
      go
      gcc14
      dig # DNS lookup
    ] ++ lib.optionals stdenv.isDarwin [
      coreutils # provides `dd` with --status=progress
      wifi-password
    ] ++ lib.optionals stdenv.isLinux [
      iputils # provides `ping`, `ifconfig`, ...
      libuuid # `uuidgen` (already pre-installed on mac)
      font-awesome # awesome fonts
      material-design-icons # fonts with glyphs
      vscode
    ];

  home.sessionVariables = {
    DISPLAY = ":0";
    EDITOR = "nvim";
    BROWSER = "firefox";
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
