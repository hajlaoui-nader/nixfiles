{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    plugins = with pkgs; [ rofi-calc rofi-emoji ];
    #terminal = "${pkgs.kitty}/bin/kitty";
    #theme = ./theme.rafi;
    extraConfig = {
      font = "Iosevka 20";
      show-icons = true;
      icon-theme = "Papirus";

    };
  };

  # for rofi-emoji to insert emojis directly
  home.packages = [ pkgs.xdotool ];
}

