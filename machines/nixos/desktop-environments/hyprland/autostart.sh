#!/usr/bin/env bash

# Kill any existing instances
pkill -f waybar
pkill -f swaync

# Wait a moment
sleep 1

# Start Waybar
waybar &

# Start notification daemon
swaync &

# Start clipboard manager
wl-paste --type text --watch cliphist store &
wl-paste --type image --watch cliphist store &

# Start authentication agent
/run/current-system/sw/libexec/polkit-kde-authentication-agent-1 &

# NetworkManager applet
nm-applet &

# Bluetooth applet
blueman-applet &