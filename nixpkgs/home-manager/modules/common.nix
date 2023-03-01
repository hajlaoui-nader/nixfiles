{ inputs, config, pkgs, pkgsUnstable, lib, ... }: {

  # https://github.com/nix-community/nix-direnv#via-home-manager
  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.packages = with pkgs;
    [
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
    bat.enable = true;

    jq.enable = true;
    ssh.enable = true;

  };

  # TODO activate neovim
  # imports = import ./editors { inherit config lib pkgs; }; 
   
  imports = [
    inputs.neovim-flake.nixosModules.hm
    ./fzf.nix
    # ./editors
    # ./nvim.nix
  ];

}
