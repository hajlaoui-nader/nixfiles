#!/usr/bin/env bash

# Desktop Environment Switcher for NixOS
# Usage: ./switch-desktop.sh [gnome|i3|hyprland|cosmic]

set -e

DE=${1:-hyprland}

echo "Switching to desktop environment: $DE"

# Validate desktop environment choice
case $DE in
  gnome|i3|hyprland|cosmic)
    echo "Valid desktop environment selected: $DE"
    ;;
  *)
    echo "Invalid desktop environment: $DE"
    echo "Available options: gnome, i3, hyprland, cosmic"
    exit 1
    ;;
esac

# Update the desktop environment in vizzia configuration
sed -i "s/desktopEnvironment = \".*\";/desktopEnvironment = \"$DE\";/" machines/nixos/vizzia/configuration.nix

echo "Updated configuration. Building new system..."

# Rebuild NixOS configuration
sudo nixos-rebuild switch --flake .#vizzia

echo "Desktop environment switched to $DE successfully!"
echo "Please log out and select $DE from the login screen."