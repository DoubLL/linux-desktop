# 510 - XDG User Directories Configuration

## Overview

XDG user directories use their standard home directory locations (`~/Desktop`, `~/Music`, etc.), but these directories are bind-mounted from the large media drive at `/mnt/media`. This provides:

- Standard, familiar paths for applications and users
- Transparent storage on the large media drive
- No need for `~/media/` prefix in paths
- Space preservation on the system SSD

## Configuration File

**Location**: `~/.config/user-dirs.dirs`

This file is automatically read by XDG-compliant applications and the file manager to determine standard directory locations.

## Current Configuration

```bash
# This file is written by xdg-user-dirs-update
# If you want to change or add directories, just edit the line you're
# interested in. All local changes will be retained on the next run.
# Format is XDG_xxx_DIR="$HOME/yyy", where yyy is a shell-escaped
# homedir-relative path, or XDG_xxx_DIR="/yyy", where /yyy is an
# absolute path. No other format is supported.
# 
XDG_DESKTOP_DIR="$HOME/Desktop"
XDG_DOWNLOAD_DIR="$HOME/Downloads"
XDG_TEMPLATES_DIR="$HOME/"
XDG_PUBLICSHARE_DIR="$HOME/Public"
XDG_DOCUMENTS_DIR="$HOME/Documents"
XDG_MUSIC_DIR="$HOME/Music"
XDG_PICTURES_DIR="$HOME/Pictures"
XDG_VIDEOS_DIR="$HOME/Videos"
```

## Directory Mappings

| XDG Variable | Location | Actual Storage | Purpose |
| ------------ | -------- | -------------- | -------- |
| `XDG_DESKTOP_DIR` | `~/Desktop` | `/mnt/media/Desktop` (bind mount) | Desktop files and shortcuts |
| `XDG_DOWNLOAD_DIR` | `~/Downloads` | `/mnt/media/Downloads` (bind mount) | Browser downloads |
| `XDG_DOCUMENTS_DIR` | `~/Documents` | `/mnt/media/Documents` (bind mount) | Personal documents |
| `XDG_MUSIC_DIR` | `~/Music` | `/mnt/media/Music` (bind mount) | Audio files |
| `XDG_PICTURES_DIR` | `~/Pictures` | `/mnt/media/Pictures` (bind mount) | Photos/images |
| `XDG_VIDEOS_DIR` | `~/Videos` | `/mnt/media/Videos` (bind mount) | Video files |
| `XDG_TEMPLATES_DIR` | `~/` | `~/` (home directory) | File templates |
| `XDG_PUBLICSHARE_DIR` | `~/Public` | `~/Public` (home directory) | Public shared files |

## Benefits of This Configuration

1. **Space Management**: Large media files stored on large media drive, not system SSD
2. **Standard Paths**: Applications see normal `~/Music`, `~/Videos` paths
3. **Transparency**: Users don't need to remember `/mnt/media/` prefix
4. **Separation**: System files on fast NVMe SSD, user data on large HDD  
5. **Persistence**: User data survives OS reinstallation if media drive is preserved
6. **Compatibility**: Works with all XDG-compliant applications without special configuration

## Application Compatibility

XDG directories are respected by:

- File managers (COSMIC Files, Nautilus, etc.)
- Web browsers (for downloads)
- Media players and viewers
- Screenshot tools
- Any XDG-compliant application

## Notes on Templates and Public

- **Templates**: Set to `~/` (home directory) as it's rarely used and doesn't need large storage
- **Public**: Remains at `~/Public` in home directory, not on media drive

## Modification

To change these directories:

1. Edit `~/.config/user-dirs.dirs` manually, or
2. Use `xdg-user-dirs-update` command
3. Changes take effect for new application instances

**Warning**: Moving directories requires manually moving the contents to the new location.

## Related Documentation

- [220_media_mount.md](220_media_mount.md) - Media drive mount configuration
- [500_configurations.md](500_configurations.md) - System configurations overview
- [200_storage.md](200_storage.md) - Overall storage configuration
