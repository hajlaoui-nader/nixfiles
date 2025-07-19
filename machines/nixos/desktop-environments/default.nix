{ desktopEnvironment ? "hyprland" }:

# Desktop Environment Selection Module
# Available options: "cosmic", "gnome", "i3", "hyprland"

let
  desktopModules = {
    cosmic = ./cosmic.nix;
    gnome = ./gnome.nix;
    i3 = ./i3.nix;
    hyprland = ./hyprland.nix;
  };
  
  selectedModule = desktopModules.${desktopEnvironment} or desktopModules.hyprland;
in
  selectedModule