# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').
{ config, pkgs, ... }:

let
  # false sets i3
  useGnome = false;
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../common-system-packages.nix
    ];
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  networking.hostName = "nixos"; # Define your hostname.
  services.fstrim.enable = true;
  programs.thunar.enable = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
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
  hardware.pulseaudio.enable = false;
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
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # Define a user account. Don't forget to set a password with 'passwd'.
  users.users.nader = {
    isNormalUser = true;
    description = "nader";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      #  thunderbird
      firefox
      git
      xclip
      libreoffice
      evince
      awscli2
      poetry
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
  # List packages installed in system profile. To search, run:
  # $ nix search wget
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
    vim
    neovim
    git
    vscode
    ghostty
    picom
    #  wget
  ] ++ (if !useGnome then [
    dmenu
    i3status
    i3lock
    i3blocks
  ] else [ ]);

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  # List services that you want to enable:
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  virtualisation = {
    docker = {
      enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
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
  fonts = {
    packages = [
      pkgs.inter
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.fira-mono
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.iosevka
    ];
  };

  # Desktop environment configuration based on useGnome
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw

  services.displayManager = {
    defaultSession = if useGnome then "gnome" else "none+i3";
    autoLogin = {
      enable = true;
      user = "nader";
    };
  };

  services.xserver = {
    enable = true;
    xkb = {
      layout = "us";
      variant = "";
      options = "compose:ralt";
    };

    # Configure based on chosen DE
    desktopManager = {
      xterm.enable = false;
      gnome.enable = useGnome;
    };

    displayManager = {
      gdm.enable = useGnome;

      # i3-specific display configuration
      setupCommands =
        if !useGnome then ''
          ${pkgs.xorg.xrandr}/bin/xrandr --newmode "2256x1504_60.00"  287.00  2256 2424 2664 3072  1504 1507 1517 1559 -hsync +vsync
          ${pkgs.xorg.xrandr}/bin/xrandr --addmode Virtual1 2256x1504_60.00
          ${pkgs.xorg.xrandr}/bin/xrandr --output Virtual1 --mode 2256x1504_60.00
        '' else "";
    };

    monitorSection =
      if !useGnome then ''
        DisplaySize 344 229
      '' else "";

    # i3 configuration
    windowManager.i3 = {
      enable = !useGnome;
      extraPackages = with pkgs; [ ];
    };
  };
  services.libinput = {
    enable = true;
    touchpad = {
      accelSpeed = "0.6"; # Increase this value for faster tracking
      # Values typically range from -1.0 to 1.0
    };
  };

  # Enable bluetooth hardware.bluetooth.enable = true;
  hardware.bluetooth = {
    powerOnBoot = true;
    enable = true;
  };
  services.blueman.enable = true;
  services.fwupd.enable = true;
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
