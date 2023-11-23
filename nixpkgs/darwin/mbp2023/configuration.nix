{ pkgs, config, lib, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [ 
      pkgs.vim
      pkgs.home-manager
    ];

  imports = [];

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
  system.defaults.dock.wvous-tl-corner=1;
  system.defaults.dock.wvous-bl-corner=1;
  system.defaults.dock.wvous-tr-corner=1;
  system.defaults.dock.wvous-br-corner=1;

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
