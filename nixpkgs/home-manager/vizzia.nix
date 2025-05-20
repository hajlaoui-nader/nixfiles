{ pkgs, gitEmail, ... }: {
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
    bitwarden-desktop
    slack
  ];

  home.file = {
    ".config/i3/config".source = ./programs/i3/i3config.conf;
    ".config/i3status/config".source = ./programs/i3/i3status.conf;
    #".config/rofi/config.rasi".source = ./programs/rofi/config.rasi;
    #".config/picom/picom.conf".source = ./programs/i3/picom/picom.conf;
  };

  # neovim snippets 
  home.shellAliases = {
    open = "thunar .";
  };

}
