{ pkgs, ... }:

{
  programs.rofi = {
    enable = true;
    plugins = with pkgs; [ rofi-calc rofi-emoji ];
    #terminal = "${pkgs.kitty}/bin/kitty";
    #theme = ./theme.rafi;
  };

  # for rofi-emoji to insert emojis directly
  home.packages = [ pkgs.xdotool ];
}

