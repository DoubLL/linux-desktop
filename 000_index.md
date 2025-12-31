# 000 - Documentation Index

## About This Documentation

This workspace contains documentation for customizations and configurations made to this Pop_OS system. The documentation follows a hierarchical structure similar to OneNote, where main topics have numbered pages (100, 200, 300) and child pages provide additional details (210, 220, 310, etc.).

**Documentation Principle**: Only custom configurations and manually installed software are documented here—not default Pop_OS features or pre-installed applications.

## Navigation

### [100 - General System Overview](100_general.md)

Pop_OS installation, desktop environment, and system-level customizations.

### [200 - Storage Configuration](200_storage.md)

Three-drive configuration with custom mount points.

**Child Pages:**

- [210 - Games Drive Mount](210_games_mount.md) - `/games` mount (1.9TB drive for Steam)
- [220 - Media Drive Mount](220_media_mount.md) - `~/media` mount (7.3TB drive with XDG directories)

### [300 - Custom Applications](300_applications.md)

Manually installed applications beyond default Pop_OS software.

**Child Pages:**

- [310 - OpenTabletDriver](310_opentabletdriver.md) - Tablet driver configuration
- [320 - rclone](320_rclone.md) - Cloud storage sync configuration
- [330 - Sidekick Browser](330_sidekick.md) - Browser installation and configuration

### [400 - Development Environment](400_development.md)

Development tools, programming languages, and project organization.

**Child Pages:**

- [410 - Python Setup](410_python_setup.md) - Python environment and package management
- [420 - Project Locations](420_project_locations.md) - Code project inventory

### [500 - System Configuration Files](500_configurations.md)

Custom configuration files and system settings.

**Child Pages:**

- [510 - XDG User Directories](510_xdg_directories.md) - Custom user directory configuration
- [520 - COSMIC Desktop](520_cosmic_desktop.md) - COSMIC desktop environment settings
- [530 - Fan Control](530_fan_control.md) - MSI motherboard fan control configuration

## Documentation Structure

### Numbering System

- **X00** (100, 200, 300, etc.) - Main topic pages
- **XX0** (210, 220, 310, etc.) - Child pages
- **XXX** (211, 212, 311, etc.) - Sub-child pages
- **000** - Meta-documentation

### File Naming Convention

Files follow the pattern `XXX_descriptive_name.md` where:

- First digit indicates the main category (1=general, 2=storage, 3=applications, etc.)
- Subsequent digits indicate hierarchy level
- Names are lowercase with underscores

## Quick Reference

### Storage

- System Drive: 1TB NVMe SSD at `/usr`
- Games Drive: 2TB at `/games`
- Media Drive: 8TB at `~/media`

### Key Directories

- `~/dev/notes` - This documentation workspace
- `~/media/Code` - Code project archive
- `~/media/Desktop`, `~/media/Documents`, etc. - XDG user directories
- `/games/Steam` - Steam game library
- `~/.config/` - Application configurations

### Development Tools

- Python 3.13.x (`/usr/bin/python3`)
- Git 2.x (`/usr/bin/git`)
- VS Code (Flatpak installation)

## Maintaining This Documentation

### Automatic Updates

The file [.github/copilot-instructions.md](.github/copilot-instructions.md) instructs GitHub Copilot to automatically update this documentation when system changes are made through this workspace.

### Manual Updates

When making changes outside of this workspace:

1. Update the relevant parent file (200, 300, 400, 500)
2. Create or update child pages with specific details
3. Add new pages to this index if necessary
4. Keep the numbering scheme consistent
