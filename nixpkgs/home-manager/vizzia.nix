{ pkgs, ... }: {
  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    ./modules/zsh
    ./modules/git.nix
    #./programs/hyprland
    ./programs/rofi
    #./programs/waybar
    ./programs/kitty.nix
    ./programs/tmux
    ./programs/ghostty
  ];

  home.stateVersion = "23.11";

  home.username = "nader";
  home.homeDirectory = "/home/nader";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    home-manager
    networkmanagerapplet
    spotify
    #nerdfonts
    iosevka
    copyq
    bitwarden-cli
    slack
  ];

  home.file = {
    ".config/i3/config".source = ./programs/i3/i3config.conf;
    ".config/i3status/config".source = ./programs/i3/i3status.conf;
  };

  # neovim snippets 
  home.shellAliases = {
    open = "xdg-open";
    generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
  };

}
