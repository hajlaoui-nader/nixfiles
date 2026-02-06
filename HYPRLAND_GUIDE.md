# 🚀 Hyprland Desktop Environment - Complete Guide

Welcome to your new Hyprland setup! This guide will help you understand and use your beautiful new desktop environment.

## What is Hyprland?

**Hyprland** is a modern, highly customizable Wayland compositor with:
- 🎨 **Beautiful animations** - Smooth, eye-catching window transitions
- 🪟 **Dynamic tiling** - Automatic window arrangement like i3/bspwm
- ⚡ **High performance** - Uses modern graphics APIs
- 🎯 **Wayland-native** - Better security, performance, and multi-monitor support
- 📐 **Proper HiDPI scaling** - Everything looks crisp on high-DPI displays

Think of it as "i3 on steroids with animations"!

## 🔧 Getting Started

### 1. Build and Switch to the New Configuration

```bash
# From your nixfiles directory
cd ~/projects/nixfiles

# Build and switch to the new configuration
sudo nixos-rebuild switch --flake .#zeus

# Reboot to start Hyprland
sudo reboot
```

### 2. First Login

After rebooting, you'll automatically log into Hyprland. You should see:
- **Waybar** at the top (status bar with workspaces, time, system info)
- **Beautiful blur effects** on windows
- **Smooth animations** when opening/closing windows

---

## ⌨️ Essential Keybindings

> **SUPER** = Windows/Command key (your main modifier)

### Applications

| Keybinding | Action |
|-----------|--------|
| `SUPER + Enter` | Open terminal (Ghostty) |
| `SUPER + D` | Open app launcher (Rofi) |
| `SUPER + B` | Open browser (Firefox) |
| `SUPER + E` | Open file manager (Thunar) |

### Window Management

| Keybinding | Action |
|-----------|--------|
| `SUPER + Shift + Q` | Close focused window |
| `SUPER + F` | Toggle fullscreen |
| `SUPER + Shift + Space` | Toggle floating |
| `SUPER + S` | Toggle split direction |
| `SUPER + C` | Center floating window |
| `SUPER + T` | Pin window (visible on all workspaces) |

### Moving Focus (Vim-style)

| Keybinding | Action |
|-----------|--------|
| `SUPER + H` | Focus window left |
| `SUPER + J` | Focus window down |
| `SUPER + K` | Focus window up |
| `SUPER + L` | Focus window right |
| `SUPER + ← ↓ ↑ →` | Focus using arrow keys |

### Moving Windows

| Keybinding | Action |
|-----------|--------|
| `SUPER + Shift + H/J/K/L` | Move window (Vim-style) |
| `SUPER + Shift + ← ↓ ↑ →` | Move window (arrows) |

### Resizing Windows

| Keybinding | Action |
|-----------|--------|
| `SUPER + R` | Enter resize mode |
| In resize mode: `H/J/K/L` or arrows | Resize window |
| `Escape` or `Enter` | Exit resize mode |
| `SUPER + Ctrl + H/J/K/L` | Quick resize (no mode) |

### Workspaces

| Keybinding | Action |
|-----------|--------|
| `SUPER + 1-9` | Switch to workspace 1-9 |
| `SUPER + Shift + 1-9` | Move window to workspace 1-9 |
| `SUPER + Ctrl + ← →` | Cycle through workspaces |
| `SUPER + Mouse Wheel` | Scroll through workspaces |

### Special Workspace (Scratchpad)

| Keybinding | Action |
|-----------|--------|
| `SUPER + -` | Toggle scratchpad (hidden workspace) |
| `SUPER + Shift + -` | Move window to scratchpad |

### Screenshots

| Keybinding | Action |
|-----------|--------|
| `Print` | Screenshot area (select with mouse) → opens Swappy editor |
| `Shift + Print` | Screenshot full screen → opens Swappy editor |
| `SUPER + Print` | Screenshot area → save to ~/Pictures/Screenshots/ |

### System Controls

| Keybinding | Action |
|-----------|--------|
| `SUPER + X` | Lock screen |
| `SUPER + Shift + E` | Exit Hyprland |
| `SUPER + Shift + R` | Reload Hyprland |
| `Volume Keys` | Adjust volume |
| `Brightness Keys` | Adjust screen brightness |

### Utilities

| Keybinding | Action |
|-----------|--------|
| `SUPER + V` | Clipboard history (Rofi) |
| `SUPER + .` | Emoji picker (Rofimoji) |
| `SUPER + N` | Close notification |
| `SUPER + Shift + C` | Color picker |

### Mouse Actions

| Action | Effect |
|--------|--------|
| `SUPER + Left Click & Drag` | Move window |
| `SUPER + Right Click & Drag` | Resize window |

---

## 📦 What's Installed

### Core Components

1. **Hyprland** - The window manager/compositor
2. **Waybar** - Status bar at the top
3. **Rofi (Wayland)** - Application launcher
4. **Swaylock** - Screen locker with blur effects
5. **Swayidle** - Auto-lock manager
6. **Dunst** - Notification daemon
7. **SWWW** - Wallpaper manager

### Utilities

- **grim + slurp** - Screenshot tools
- **swappy** - Screenshot editor
- **cliphist** - Clipboard manager
- **brightnessctl** - Brightness control
- **pamixer** - Audio control
- **playerctl** - Media control
- **btop** - System monitor
- **thunar** - File manager

---

## 🎨 Customization

### Changing Scaling (If Things Are Still Too Small/Large)

Edit `~/.config/hypr/monitors.conf`:

```conf
# Current setting: 1.5x scaling
monitor=,preferred,auto,1.5

# For larger UI, try:
# monitor=,preferred,auto,1.75
# or
# monitor=,preferred,auto,2.0

# For smaller UI:
# monitor=,preferred,auto,1.25
```

Then reload: `SUPER + Shift + R`

### Changing Wallpaper

```bash
# Set a wallpaper
swww img /path/to/your/wallpaper.jpg

# Or create ~/Pictures/wallpaper.jpg and it will load automatically
```

### Changing Color Scheme

All colors use **Catppuccin Mocha** theme. To change:
1. Edit `~/.config/hypr/general.conf` for border colors
2. Edit `~/.config/waybar/style.css` for waybar colors
3. Edit `~/.config/rofi/catppuccin-mocha.rasi` for rofi colors

### Adjusting Animations

Edit `~/.config/hypr/animations.conf` to:
- Speed up/slow down animations
- Disable animations
- Change animation curves

---

## 🔍 Understanding the Layout

Hyprland uses **dwindle layout** (similar to i3):
- New windows automatically tile
- Windows split horizontally or vertically based on available space
- Use `SUPER + S` to toggle split direction

### Workspace Workflow

1. **Workspace 1**: Terminal/Development
2. **Workspace 2**: Browser (Firefox auto-assigned)
3. **Workspace 3**: Communication (Slack, Discord)
4. **Workspace 4**: Media (Spotify)
5. **Workspace 5+**: Your choice!

---

## 🐛 Troubleshooting

### Screen Is Blank After Login
- Press `SUPER + D` to open Rofi
- Type "waybar" and press Enter
- Check logs: `journalctl -b --user -u Hyprland`

### Scaling Issues
- Adjust in `~/.config/hypr/monitors.conf`
- Some apps may need restart to apply new scaling

### Rofi Not Showing Icons
- Install: `nix-shell -p papirus-icon-theme`
- Set in GTK settings

### Firefox Not Using Wayland
- Check `MOZ_ENABLE_WAYLAND=1` in `~/.config/hypr/environment.conf`
- About:support in Firefox should show "Window Protocol: wayland"

---

## 🎓 Learning More

- **Hyprland Wiki**: https://wiki.hyprland.org/
- **Keybindings**: `~/.config/hypr/binds.conf`
- **General Config**: `~/.config/hypr/general.conf`
- **Visual Effects**: `~/.config/hypr/decoration.conf`

---

## 🚀 Pro Tips

1. **Use workspaces**: Each workspace is independent - spread your windows across multiple workspaces

2. **Master the scratchpad**: Use `SUPER + -` for a hidden workspace - great for quick access to a terminal or notes

3. **Group windows**: `SUPER + G` creates tabbed containers (like i3's tabbed mode)

4. **Resize with mouse**: Hold `SUPER + Right Click` to resize any window quickly

5. **Clipboard history**: `SUPER + V` shows your clipboard history - super useful!

6. **Quick launcher**: `SUPER + Shift + D` opens command runner - type any command

7. **Trackpad gestures**: Swipe 3 fingers left/right to switch workspaces

---

## 📝 Quick Reference Card

Print this out or keep it handy:

```
┌─────────────────────────────────────────────────────────┐
│              HYPRLAND CHEAT SHEET                       │
├─────────────────────────────────────────────────────────┤
│ SUPER = Windows/Command Key                             │
├─────────────────────────────────────────────────────────┤
│ SUPER + Enter         → Terminal                        │
│ SUPER + D             → App Launcher                    │
│ SUPER + B             → Browser                         │
│ SUPER + Shift + Q     → Close Window                    │
│ SUPER + F             → Fullscreen                      │
│ SUPER + H/J/K/L       → Move Focus                      │
│ SUPER + Shift + H/J/K/L → Move Window                   │
│ SUPER + 1-9           → Switch Workspace                │
│ SUPER + R             → Resize Mode                     │
│ SUPER + X             → Lock Screen                     │
│ SUPER + V             → Clipboard History               │
│ Print                 → Screenshot                      │
└─────────────────────────────────────────────────────────┘
```

---

## ✅ Next Steps

1. **Rebuild your system**: `sudo nixos-rebuild switch --flake .#zeus`
2. **Reboot**: `sudo reboot`
3. **Explore**: Try opening apps, moving windows, switching workspaces
4. **Customize**: Adjust colors, wallpapers, keybindings to your taste
5. **Enjoy**: You now have one of the most beautiful Linux desktops! 🎉

---

Happy Hyprland-ing! If you need help, check your config files in `~/.config/hypr/` or ask me!
