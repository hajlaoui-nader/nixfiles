{ lib, pkgs, ... }:
{
  # Hyprland configuration files
  home.file = {
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/hypr/settings.conf".source = ./settings.conf;
    ".config/hypr/binds.conf".source = ./binds.conf;
    ".config/hypr/autostart.sh" = {
      source = ./autostart.sh;
      executable = true;
    };
  };

  # Waybar configuration
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = builtins.fromJSON (builtins.readFile ./waybar-config.json);
    };
    style = builtins.readFile ./waybar-style.css;
  };

  # Wofi configuration
  home.file = {
    ".config/wofi/config".source = ./wofi-config;
    ".config/wofi/style.css".source = ./wofi-style.css;
  };

  # Clipboard manager service
  systemd.user.services.cliphist = {
    Unit = {
      Description = "Clipboard history service";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.wl-clipboard}/bin/wl-paste --type text --watch ${pkgs.cliphist}/bin/cliphist store";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "default.target" ];
  };

  # Notification service
  services.swaync = {
    enable = true;
  };

  # Additional packages for the desktop environment
  home.packages = with pkgs; [
    # Clipboard manager
    cliphist
    
    # Screenshot tools
    grim
    slurp
    
    # Media control
    playerctl
    
    # Image viewer
    imv
    
    # PDF viewer
    zathura
  ];
}