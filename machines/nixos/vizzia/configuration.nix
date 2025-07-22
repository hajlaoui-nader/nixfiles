# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{ config, pkgs, ... }:
let
  # Desktop environment selection
  # Options: "cosmic", "gnome", "i3"
  desktopEnvironment = "gnome";
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../common-system-packages.nix
    ../../common-linux-system-packages.nix
    # Desktop environment modules
    (../desktop-environments + "/${desktopEnvironment}.nix")
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  services.fstrim.enable = true;
  programs.thunar.enable = true;

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire = {
      "99-disable-bell" = {
        "context.properties" = {
          "module.x11.bell" = false;
        };
      };
    };
  };

  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.nader = {
    isNormalUser = true;
    description = "nader";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      git
      xclip
      libreoffice
      evince
      awscli2
      poetry
      python311
      uv
      nodePackages_latest.aws-cdk
    ];
  };

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Base system packages
  environment.systemPackages = with pkgs; [
    acpi
    playerctl
    pamixer
    xorg.xbacklight
    xorg.xev
    brightnessctl
    dunst
    lxappearance
    pipewire
    caffeine-ng
    vim
    neovim
    git
    vscode
    ghostty
    picom
    rofimoji
    openvpn3
    wget
    bc
  ];

  # Docker configuration
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };

  # Nix configuration
  nix = {
    settings.auto-optimise-store = true;
    extraOptions = ''
      # needed for nix-direnv
      keep-outputs = true
      keep-derivations = true
      # assuming the builder has a faster internet connection
      builders-use-substitutes = true
      experimental-features = nix-command flakes
    '';
    # Perform garbage collection weekly to maintain low disk usage
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 1w";
    };
  };

  # Fonts
  fonts = {
    packages = [
      pkgs.inter
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.fira-mono
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.iosevka
    ];
  };

  # Input configuration
  services.libinput = {
    enable = true;
    touchpad = {
      accelSpeed = "0.6";
    };
  };

  # Enable bluetooth
  hardware.bluetooth = {
    powerOnBoot = true;
    enable = true;
  };

  services.fwupd.enable = true;

  # VPN configuration
  services.openvpn.servers = {
    vizzia-prod = {
      config = "config /home/nader/vpn/vizzia-prod.ovpn";
      autoStart = false;
      updateResolvConf = true;
    };
    vizzia-dev = {
      config = "config /home/nader/vpn/vizzia-dev.ovpn";
      autoStart = false;
      updateResolvConf = true;
    };
  };

  # Power Management
  boot.kernelParams = [
    "amd_pstate=active"
    "amdgpu.ppfeaturemask=0xffffffff"
    "amdgpu.runpm=1"
  ];
  services.power-profiles-daemon.enable = true;

  system.stateVersion = "24.11";
}
