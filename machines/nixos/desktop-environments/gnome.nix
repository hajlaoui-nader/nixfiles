{ config, pkgs, ... }:

{
  # X11 configuration for GNOME
  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
      options = "compose:ralt";
    };

    desktopManager = {
      xterm.enable = false;
      gnome.enable = true;
    };

    displayManager = {
      gdm.enable = true;
    };
  };

  # Display manager configuration
  services.displayManager = {
    defaultSession = "gnome";
    autoLogin = {
      enable = true;
      user = "nader";
    };
  };

  # GNOME-specific packages
  environment.systemPackages = with pkgs; [
    # GNOME Extensions
    gnome-extensions-cli
    # Clipboard manager options for GNOME
    copyq
    # Or use GNOME's built-in clipboard
    gnome-shell-extensions
  ];

  # GNOME services
  services.gnome = {
    gnome-keyring.enable = true;
    evolution-data-server.enable = true;
    gnome-browser-connector.enable = true;
  };

  # Exclude some default GNOME applications if desired
  environment.gnome.excludePackages = with pkgs; [
    # gnome-tour
    # epiphany # web browser
    # geary # email reader
    # totem # video player
  ];
}
