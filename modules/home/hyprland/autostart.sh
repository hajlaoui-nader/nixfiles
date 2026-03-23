#!/usr/bin/env bash

# init wallpaper daemon
swww init &
# setting wallpaper
## set wallpaper from local

nm-applet --indicator &
# start waybar
waybar &

# start dunst
dunst

