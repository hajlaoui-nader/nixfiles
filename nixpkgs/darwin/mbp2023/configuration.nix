{ pkgs, config, lib, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # environment.systemPackages =
  #   [ pkgs.vim
  #   ];

  imports = [
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;

    # Currently disabled `nix.settings.auto-optimise-store` as it seems to fail with remote builders
    # TODO renable when fixed https://github.com/NixOS/nix/issues/7273
    settings.auto-optimise-store = false;

    extraOptions = ''
      # needed for nix-direnv
      keep-outputs = true
      keep-derivations = true

      # assuming the builder has a faster internet connection
      builders-use-substitutes = true

      experimental-features = nix-command flakes
    '';

    buildMachines = lib.filter (x: x.hostName != config.networking.hostName) [
      {
        systems = [ "aarch64-linux" "x86_64-linux" ];
        sshUser = "root";
        maxJobs = 4;
        # relies on `/var/root/.ssh/nix-builder` key to be there
        # TODO set this up via nix
        hostName = "oracle-nix-builder";
        supportedFeatures = [ "nixos-test" "benchmark" "kvm" "big-parallel" ];
      }
    ];
    distributedBuilds = config.nix.buildMachines != [ ];
  };


  security.pam.enableSudoTouchIdAuth = true;

  programs = {
    zsh.enable = true;
  };

  environment.shells = [ pkgs.fish ];

  users.users.naderhajlaoui = {
    home = "/Users/naderhajlaoui";
    shell = "${pkgs.fish}/bin/zsh";
  };
  users.users.root = {
    home = "/var/root";
    shell = "${pkgs.fish}/bin/zsh";
  };

  # can be read via `defaults read NSGlobalDomain`
  system.defaults.NSGlobalDomain = {
    InitialKeyRepeat = 15; # unit is 15ms, so 500ms
    KeyRepeat = 2; # unit is 15ms, so 30ms
    NSDocumentSaveNewDocumentsToCloud = false;
    ApplePressAndHoldEnabled = false;
    AppleShowScrollBars = "WhenScrolling";
    AppleShowAllExtensions = true;
  };
  system.defaults.dock.autohide = true;

  system.keyboard.enableKeyMapping = true;
  system.keyboard.remapCapsLockToEscape = true;

  fonts = {
    fontDir.enable = true;
    fonts = [
      pkgs.inter
      (pkgs.nerdfonts.override {
        fonts = [
          "FiraCode"
          "FiraMono"
          "JetBrainsMono"
          "SourceCodePro"
        ];
      })
    ];
  };

  system.stateVersion = 4;
}
