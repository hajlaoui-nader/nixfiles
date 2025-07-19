# Hyprland Desktop Environment for Vizzia

A complete Hyprland desktop environment setup with all the features you requested.

## Features

### Top Bar (Waybar)
- **Left**: Workspace indicators with custom icons
- **Center**: Date and time display
- **Right**: System status (WiFi, Bluetooth, Audio, Brightness, Battery, CPU, Memory, Temperature, System Tray)

### Key Bindings
- **Super + Enter**: Open Ghostty terminal
- **Super + D**: Launch application menu (Wofi)
- **Super + H/J/K/L**: Move focus (vim-like)
- **Super + Arrow Keys**: Move focus (arrow keys)
- **Super + Shift + H/J/K/L**: Move window (vim-like)
- **Super + Shift + Arrow Keys**: Move window (arrow keys)
- **Super + 1-9,0**: Switch to workspace
- **Super + Shift + 1-9,0**: Move window to workspace
- **Super + Q**: Close window
- **Super + F**: Toggle floating
- **Super + Escape**: Fullscreen

### Media Keys
- **Volume Up/Down/Mute**: Audio control
- **Brightness Up/Down**: Screen brightness
- **Play/Pause/Next/Previous**: Media control

### Screenshot
- **Print**: Screenshot selection to clipboard
- **Super + Print**: Full screenshot to clipboard
- **Super + Shift + S**: Screenshot selection to file

## Font Configuration
Uses **Iosevka Nerd Font** throughout the desktop environment for consistent typography with excellent Unicode support.

## Applications Included
- **Terminal**: Ghostty
- **File Manager**: Thunar
- **Application Launcher**: Wofi
- **Notification Daemon**: SwayNC
- **Clipboard Manager**: cliphist
- **Screenshot Tools**: grim + slurp

## How to Use

### Switch to Hyprland
```bash
cd ~/nixfiles
./switch-desktop.sh hyprland
```

### Manual Configuration Edit
Edit `machines/nixos/vizzia/configuration.nix` and change:
```nix
desktopEnvironment = "hyprland";
```

Then rebuild:
```bash
sudo nixos-rebuild switch --flake .#vizzia
```

### Available Desktop Environments
- `gnome` - GNOME desktop
- `i3` - i3 window manager
- `hyprland` - Hyprland compositor
- `cosmic` - COSMIC desktop

## Customization

### Waybar
- Config: `waybar-config.jsonc`
- Styles: `waybar-style.css`

### Wofi (App Launcher)
- Config: `wofi-config`
- Styles: `wofi-style.css`

### Hyprland
- Main config: `hyprland.conf`
- Window manager settings: `settings.conf`
- Key bindings: `binds.conf`
- Startup applications: `autostart.sh`

## Color Scheme
Uses Catppuccin Mocha color scheme throughout for a cohesive dark theme experience.

## After Installation
1. Log out of your current session
2. At the login screen (GDM), select "Hyprland" from the session menu
3. Log in to enjoy your new Hyprland desktop environment!