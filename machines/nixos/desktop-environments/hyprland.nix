{ config, pkgs, ... }:
{
  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Display Manager for multiple desktop environments
  services.xserver = {
    enable = true;
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
      };
    };
  };

  # Session management
  services.displayManager = {
    defaultSession = "hyprland";
  };

  # Enable necessary services for Wayland
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # NetworkManager for WiFi
  networking.networkmanager.enable = true;

  # Polkit for authentication
  security.polkit.enable = true;

  # System packages for Hyprland
  environment.systemPackages = with pkgs; [
    # Core Wayland tools
    waybar
    wofi
    wl-clipboard
    wlr-randr
    swaynotificationcenter

    # Screenshot and screen recording
    grim
    slurp
    wf-recorder

    # File manager
    #thunar
    #thunar-volman

    # Image viewer
    imv

    # Terminal
    ghostty

    # Clipboard manager
    cliphist

    # Audio control
    pavucontrol
    pamixer

    # Network management
    networkmanagerapplet

    # Brightness control
    brightnessctl

    # Power management
    acpi

    # Authentication agent
    kdePackages.polkit-kde-agent-1

    # PDF viewer
    zathura

    # Archive manager
    file-roller
  ];

  # Fonts with Iosevka Nerd Font
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    liberation_ttf
    nerd-fonts.iosevka
    font-awesome
  ];

  # Session variables
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # Auto-login configuration (optional - commented out for multi-DE setup)
  # services.displayManager.autoLogin = {
  #   enable = true;
  #   user = "nader";
  # };
}
