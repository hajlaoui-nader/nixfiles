{ pkgs, ... }: {
  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    ./modules/zsh
    ./modules/git.nix
    #./programs/hyprland
    #./programs/rofi
    #./programs/waybar
    ./programs/kitty.nix
    ./programs/tmux
  ];

  home.stateVersion = "23.11";

  home.username = "zeus";
  home.homeDirectory = "/home/zeus";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    home-manager
    networkmanagerapplet
    spotify
    #nerdfonts
    iosevka
    copyq
    bitwarden-cli
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FiraMono"
        "JetBrainsMono"
        "SourceCodePro"
      ];
    })
  ];

  # neovim snippets 
  home.shellAliases = {
    open = "xdg-open";
    generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
  };

}
