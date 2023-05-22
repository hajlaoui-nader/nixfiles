{ pkgs, config, lib, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ pkgs.vim
    ];

  imports = [
  ];

  # # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nix;

    settings.auto-optimise-store = true;

    extraOptions = ''
      # needed for nix-direnv
      keep-outputs = true
      keep-derivations = true

      # assuming the builder has a faster internet connection
      builders-use-substitutes = true

      experimental-features = nix-command flakes
    '';
  };


  security.pam.enableSudoTouchIdAuth = true;

  programs = {
    zsh.enable = true;
  };

 # environment.shells = [ pkgs.fish ];

  users.users.naderh = {
    home = "/Users/naderh";
    shell = "${pkgs.fish}/bin/zsh";
  };
  users.users.root = {
    home = "/var/root";
    shell = "${pkgs.fish}/bin/zsh";
  };

  # # can be read via `defaults read NSGlobalDomain`
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

  # finder
  system.defaults.finder.ShowStatusBar = true;
  # list icons
  system.defaults.finder.FXPreferredViewStyle = "Nlsv";

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
