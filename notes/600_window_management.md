# 600 - Window Management

## Overview

This system supports two desktop environments / window managers:

1. **COSMIC** (Default) - System76's modern Wayland-based desktop environment
2. **i3** (Installed) - Lightweight X11 tiling window manager for power users

Both can be used simultaneously, switched at login. This page provides an overview; detailed configuration for each is documented separately.

## Current Setup

### Default: COSMIC (Wayland)

- Installed and currently set as default desktop environment
- Modern, user-friendly interface
- Limited programmatic window control (Wayland limitation)
- Good for general desktop use

### Alternative: i3 (X11)

- Installed and fully configured
- Tiling window manager with keyboard-centric workflow
- Excellent multi-monitor support with per-monitor workspaces
- Ideal for messengers workspace on secondary monitor
- Requires learning keybindings but very efficient

## Related Documentation

- [610_cosmic.md](610_cosmic.md) - COSMIC desktop environment setup
- [620_i3.md](620_i3.md) - i3 window manager installation and configuration
- [630_i3_workspaces.md](630_i3_workspaces.md) - i3 workspace layout and assignment
- [631_messengers_workspace.md](631_messengers_workspace.md) - Messengers workspace on secondary monitor

## Quick Reference

### COSMIC Shortcuts

- **Super (Windows key) + Space** - Application launcher
- **Super + Page Down/Up** - Switch workspaces (if created)
- **Drag window** - Move and arrange windows manually

### i3 Shortcuts

- **Alt + 1-6** - Switch to numbered workspace
- **Alt + Shift + 1-6** - Move window to workspace
- **Alt + Shift + C** - Reload config
- **Alt + Shift + E** - Exit i3 (logout)

See [620_i3.md](620_i3.md) for complete i3 keybindings.

---

## Technical Details

### COSMIC

- **Display Server**: Wayland
- **Compositor**: COSMIC Comp
- **Config Location**: `~/.config/cosmic/`
- **File Manager**: Nautilus
- **App Launcher**: COSMIC App Library / App Menu

### i3

- **Display Server**: X11
- **Window Manager**: i3 (tiling)
- **Config Location**: `~/.config/i3/`
- **Status Bar**: i3blocks
- **App Launcher**: dmenu (or rofi if installed)
- **Terminal**: x-terminal-emulator (alias)

---

Config files symlinked to:

- `~/.config/i3/config`
- `~/.config/i3blocks/config`
- `~/.xinitrc`
- `~/.Xresources`

All configs are under version control in `~/dev/i3/` for easy reference and modification.
