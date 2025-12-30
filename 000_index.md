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

### Custom Software

- OpenTabletDriver - Graphics tablet support
- rclone - Cloud storage sync
- Sidekick - Productivity browser
- Steam - Gaming platform

## Maintaining This Documentation

### Automatic Updates

The file [.github/copilot-instructions.md](.github/copilot-instructions.md) instructs GitHub Copilot to automatically update this documentation when system changes are made through this workspace.

### Manual Updates

When making changes outside of this workspace:

1. Update the relevant parent file (200, 300, 400, 500)
2. Create or update child pages with specific details
3. Add new pages to this index if necessary
4. Keep the numbering scheme consistent

### What to Document

- Custom installed applications
- Modified configuration files
- Custom mount points and storage
- Development tool versions and setups
- Non-default system settings

Do not document:

- Default Pop_OS features
- Pre-installed software
- Standard system configurations

## File List

### Main Pages (X00)

1. [000_index.md](000_index.md) - This file
2. [100_general.md](100_general.md) - General system overview
3. [200_storage.md](200_storage.md) - Storage configuration
4. [300_applications.md](300_applications.md) - Custom applications
5. [400_development.md](400_development.md) - Development environment
6. [500_configurations.md](500_configurations.md) - Configuration files

### Storage Pages (2XX)

- [210_games_mount.md](210_games_mount.md) - Games drive details
- [220_media_mount.md](220_media_mount.md) - Media drive details

### Application Pages (3XX)

- [310_opentabletdriver.md](310_opentabletdriver.md) - OpenTabletDriver setup
- [320_rclone.md](320_rclone.md) - rclone configuration
- [330_sidekick.md](330_sidekick.md) - Sidekick browser

### Development Pages (4XX)

- [410_python_setup.md](410_python_setup.md) - Python environment
- [420_project_locations.md](420_project_locations.md) - Project inventory

### Configuration Pages (5XX)

- [510_xdg_directories.md](510_xdg_directories.md) - XDG directory configuration
- [520_cosmic_desktop.md](520_cosmic_desktop.md) - COSMIC desktop settings

### Meta Files

- [.github/copilot-instructions.md](.github/copilot-instructions.md) - Copilot documentation maintenance instructions

---
