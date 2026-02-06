{ pkgs, ... }: {
  imports = [
    ./modules/home-manager.nix
    ./modules/common.nix
    ./modules/zsh
    ./modules/git.nix
    ./programs/hyprland
    ./programs/rofi
    ./programs/waybar
    ./programs/kitty.nix
    ./programs/tmux
    ./programs/ghostty
    ./programs/dunst.nix
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
  ];

  # Cursor theme configuration
  home.pointerCursor = {
    gtk.enable = true;
    name = "Bibata-Modern-Classic";
    package = pkgs.bibata-cursors;
    size = 32;
  };

  # GTK theme for better integration
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern-Classic";
      package = pkgs.bibata-cursors;
      size = 32;
    };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  # i3 config - commented out since we're using Hyprland now
  # home.file = {
  #   ".config/i3/config".source = ./programs/i3/i3config.conf;
  #   ".config/i3status/config".source = ./programs/i3/i3status.conf;
  # };

  # neovim snippets 
  home.shellAliases = {
    open = "xdg-open";
    generations = "sudo nix-env --list-generations --profile /nix/var/nix/profiles/system";
  };

}
