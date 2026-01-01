# 500 - System Configuration Files

## Overview

This page documents custom configuration files and system settings that have been modified from the default Pop_OS setup.

## XDG User Directories

The standard Linux user directories (Desktop, Documents, Downloads, etc.) have been redirected to the large `~/media` drive instead of the default locations in the home directory.

**Configuration File**: `~/.config/user-dirs.dirs`

This allows user files to be stored on the large media drive while keeping the system drive clean.

See [510_xdg_directories.md](510_xdg_directories.md) for the complete configuration.

## Terminal and X11 Configuration (Xresources)

Terminal appearance settings (colors, fonts, transparency) are defined in Xresources format.

**Loaded via i3 autostart**: `xrdb -merge -I$HOME ~/.config/Xresources`

The Xresources file defines:

- Terminal colors (16-color palette)
- Font settings and sizes
- Transparency and shading
- Cursor appearance
- Scrollbar and border settings

Note: Xresources is loaded at i3 startup by the autostart command in `~/.config/i3/config`. When using GDM/COSMIC login, `.xinitrc` is not used, so manual loading via `xrdb` is required.

## COSMIC Desktop Environment

The system uses System76's COSMIC desktop environment (not GNOME Shell).

**Configuration Directory**: `~/.config/cosmic/`

COSMIC settings and customizations are stored in this directory.

See [520_cosmic_desktop.md](520_cosmic_desktop.md) for desktop-specific configurations.

## Fan Control

Custom fan control configuration for MSI MPG X570 GAMING PLUS motherboard using lm-sensors and fancontrol.

**Configuration File**: `/etc/fancontrol`
**Module Configuration**: `/etc/modules-load.d/sensors.conf`

Replaces BIOS automatic fan curves with quieter Linux-controlled curves optimized for low noise at idle.

See [530_fan_control.md](530_fan_control.md) for complete setup and configuration details.

## Application Configurations

### OpenTabletDriver

**Location**: `~/.config/OpenTabletDriver/settings.json`

Contains tablet area, button mappings, and driver settings.

### rclone

**Location**: `~/.config/rclone/rclone.conf`

Contains cloud storage remote configurations (encrypted).

### Sidekick Browser

**Location**: `~/.config/sidekick/`

Browser-specific settings and cache.

### Audio Configuration

**Configuration Files:**

- `~/dev/scripts/audio-aliases.sh` - Shell aliases for audio switching
- `~/dev/services/audio-surround.service` - Systemd service for autostart
- `~/.config/pavucontrol.ini` - PulseAudio volume control settings
- `~/.config/pipewire/` - PipeWire audio system configuration

**Shell Integration:**

`~/.bashrc` sources `~/dev/scripts/audio-aliases.sh` to provide convenient commands for switching audio configurations.

**Autostart:**

A systemd user service (`audio-surround.service`) automatically enables 5.1 surround sound on login.

See [540_audio.md](540_audio.md) for complete audio setup and usage details.

## Other Configuration Directories

The following configuration directories exist but may be using default or minimal customization:

- `~/.config/gtk-3.0/` - GTK3 theme settings
- `~/.config/gtk-4.0/` - GTK4 theme settings
- `~/.config/mozilla/` - Firefox/Mozilla settings
- `~/.config/systemd/` - User systemd services

## Missing Default Files

**Note**: No `/etc/fstab` file was found, which is unusual. Drive mounts may be managed through:

- systemd mount units
- GNOME Disks / COSMIC settings auto-mount
- Other mechanisms

This should be investigated to ensure mount persistence.

## Related Documentation

- [510_xdg_directories.md](510_xdg_directories.md) - XDG user directories configuration
- [520_cosmic_desktop.md](520_cosmic_desktop.md) - COSMIC desktop settings
- [530_fan_control.md](530_fan_control.md) - Fan control configuration
- [540_audio.md](540_audio.md) - Audio system configuration and management
- [300_applications.md](300_applications.md) - Application-specific configurations
