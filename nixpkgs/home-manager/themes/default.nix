{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    gruvbox-gtk-theme
    pop-gtk-theme
  ];

  gtk = {
    enable = true;
    font.name = "JetBrainsMono 11";
    theme = {
      name = "pop";
    };
    cursorTheme = {
      name = "popc";
      size = 24;
    };
  };

  qt = {
    enable = true;
    platformTheme = "gtk";
  };

  home.sessionVariables = {
    XCURSOR_THEME = "pop";
    XCURSOR_SIZE = "24";
  };
}

