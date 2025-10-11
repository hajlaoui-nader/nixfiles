{ pkgs, config, lib, inputs, ... }:
{
  imports = [
    ../../common-system-packages.nix
  ];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowBroken = true;


  # Auto upgrade nix package and the daemon service.

  nix = {
    enable = false; # handled by determinate systems
    package = pkgs.nix;
    settings = {
      trusted-users = [ "naderh" ];
      substituters = [
        "https://cache.garnix.io"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
    };

    # Optimize storage
    # You can also manually optimize the store via:
    #    nix-store --optimise
    # Refer to the following link for more details:
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    # optimise.automatic = true;

    extraOptions = ''
      # needed for nix-direnv
      keep-outputs = true
      keep-derivations = true

      # assuming the builder has a faster internet connection
      builders-use-substitutes = true

      experimental-features = nix-command flakes
    '';

    registry.nixpkgs.flake = inputs.nixpkgs-unstable;

  };

  # Perform garbage collection weekly to maintain low disk usage
  # nix.gc = {
  #   automatic = true;
  #   interval = { Weekday = 0; Hour = 0; Minute = 0; };
  #   options = "--delete-older-than 1w";
  # };

  programs = {
    zsh.enable = true;
  };

  # environment.shells = [ pkgs.fish ];

  users.users.naderh = {
    home = "/Users/naderh";
    shell = "${pkgs.zsh}/bin/zsh";
  };
  users.users.root = {
    home = "/var/root";
    shell = "${pkgs.zsh}/bin/zsh";
  };
  system.primaryUser = "naderh";
  # # can be read via `defaults read NSGlobalDomain`
  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15; # unit is 15ms, so 500ms
    KeyRepeat = 2; # unit is 15ms, so 30ms
    NSDocumentSaveNewDocumentsToCloud = false;
    ApplePressAndHoldEnabled = false;
    AppleShowScrollBars = "WhenScrolling";
    AppleShowAllExtensions = true;
    "com.apple.keyboard.fnState" = false; # Use F1, F2, etc. keys as standard function keys
    "com.apple.mouse.tapBehavior" = 1; # trackpad tap to click
  };

  system.defaults.dock.autohide = true;
  system.keyboard.enableKeyMapping = true;

  # finder
  system.defaults.finder.ShowStatusBar = true;
  # list icons
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";

  # diable all hot corners
  # https://daiderd.com/nix-darwin/manual/index.html#opt-system.defaults.dock.wvous-tl-corner
  system.defaults.dock.wvous-tl-corner = 1;
  system.defaults.dock.wvous-bl-corner = 1;
  system.defaults.dock.wvous-tr-corner = 1;
  system.defaults.dock.wvous-br-corner = 1;

  fonts = {
    packages = [
      pkgs.inter
      pkgs.nerd-fonts.fira-code
      pkgs.nerd-fonts.fira-mono
      pkgs.nerd-fonts.jetbrains-mono
      pkgs.nerd-fonts.iosevka
    ];
  };

  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 4;
}
