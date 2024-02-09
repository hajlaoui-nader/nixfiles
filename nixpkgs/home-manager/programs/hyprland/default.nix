{ lib, pkgs, inputs, ... }: {
  home.file = {
    ".config/hypr/hyprland.conf".source = ./hyprland.conf;
    ".config/hypr/settings.conf".source = ./settings.conf;
    ".config/hypr/binds.conf".source = ./binds.conf;
    ".config/hypr/autostart.sh".source = ./autostart.sh;

  };
}

