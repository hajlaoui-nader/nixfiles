{ config, pkgs, ... }:

{
  # COSMIC Desktop Environment configuration
  services.desktopManager.cosmic.enable = true;

  # Display manager for COSMIC (uses GDM on Wayland)
  services.displayManager = {
    cosmic-greeter.enable = true;
    defaultSession = "cosmic";
    autoLogin = {
      enable = true;
      user = "nader";
    };
  };

  # X11 is disabled for COSMIC since it uses Wayland
  services.xserver.enable = false;

  # COSMIC-specific packages
  environment.systemPackages = with pkgs; [
    # Add COSMIC-specific clipboard manager
    cliphist
    # Wayland utilities
    wl-clipboard
    wl-clip-persist
  ];

  # Enable wayland-specific services
  programs.wayland.enable = true;

  # XDG portal for COSMIC
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };
}
