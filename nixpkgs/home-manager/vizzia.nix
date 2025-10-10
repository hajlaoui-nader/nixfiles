{ pkgs, unstable, gitEmail, ... }:
let cursor = pkgs.callPackage ./cursor/cursor.nix { };
in {

  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    ./modules/zsh
    ./modules/git.nix
    #./programs/hyprland
    #./programs/rofi
    #./programs/waybar
    #./programs/kitty.nix
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
    cursor
    (unstable.postman)
    unstable.bruno
    gnome-tweaks
    arc-theme
    #papirus-icon-theme
    unstable.catppuccin-gtk
    unstable.catppuccin-papirus-folders
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

  programs.zsh = {
    initContent = ''
      # VPN Management Functions
      function connect_vpn() {
        sudo systemctl start openvpn-vizzia-$1.service
      }

      function disconnect_vpn() {
        sudo systemctl stop openvpn-vizzia-$1.service
      }

      function vpn_sessions() {
        local sessions=$(sudo systemctl list-units --type=service | grep openvpn-vizzia)

        if [ -z "$sessions" ]; then
          echo "No VPN sessions found"
        else
          echo "Active VPN sessions:"
          echo "$sessions"
        fi
      }
    '';
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      gtk-theme = "Catppuccin-Macchiato-Standard-Blue-Dark";
      icon-theme = "Papirus-Dark"; # patched by catppuccin-papirus-folders
      cursor-theme = "Adwaita";
      color-scheme = "prefer-dark";
    };
  };
}
