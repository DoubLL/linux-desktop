# 300 - Applications

## Overview

This page documents applications that were manually installed beyond the default Pop_OS setup and have some special configuration or usage notes.

## Important Applications

### rclone

Command-line tool for syncing files with cloud storage providers.

**Configuration Location**: `~/.config/rclone/rclone.conf`

See [320_rclone.md](320_rclone.md) for setup and usage details.

### Steam

Gaming platform for managing and playing games. Installed with library on dedicated `/games` drive.

**Library Location**: `/games/Steam`

Game installations are stored on the `/games` mount to preserve system drive space.

## Gaming Tools

See [330_gamingtools.md](330_gamingtools.md) for details on gaming-related applications and configurations.

## Manually Installed Applications

### Installed through AppImage

#### PoE Sidekick

- **Download Source**: `https://sidekick-poe.github.io/`
- **Installation Location**: `~/.local/bin/sidekick`  
- **Configuration Location**: `~/.config/sidekick/`
- **Launcher File**: `~/.local/share/applications/sidekick.desktop`

### Manual Compilation

#### OpenTabletDriver

Graphics tablet driver for supporting drawing tablets on Linux.

**Configuration Location**: `~/.config/OpenTabletDriver/`

See [310_opentabletdriver.md](310_opentabletdriver.md) for installation and configuration details.

## Related Documentation

- [310_opentabletdriver.md](310_opentabletdriver.md) - OpenTabletDriver setup
- [320_rclone.md](320_rclone.md) - rclone cloud sync configuration
- [330_gamingtools.md](330_gamingtools.md) - Gaming tools and configurations
- [200_storage.md](200_storage.md) - Storage configuration for Steam library
