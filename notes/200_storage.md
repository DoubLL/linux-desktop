# 200 - Storage Configuration

## Overview

This system has three main storage devices configured for different purposes:

1. **NVMe SSD** - System files mounted at `/usr`
2. **Secondary Drive** - Game storage mounted at `/games`
3. **Tertiary Drive** - Personal files mounted at `~/media`

## Custom Mount Points

### /games Mount

A dedicated 1.9TB drive for game installations, primarily Steam library.

**Current Contents:**

- Steam library and installation files

See [210_games_mount.md](210_games_mount.md) for detailed configuration.

### Media Drive (/mnt/media)

A large 7.3TB drive mounted at `/mnt/media` with specific directories bind-mounted to home directory for seamless access.

**Primary Mount**: `/mnt/media`

**Bind Mounts to Home**:

- `/mnt/media/Desktop` → `$HOME/Desktop`
- `/mnt/media/Documents` → `$HOME/Documents`
- `/mnt/media/Downloads` → `$HOME/Downloads`
- `/mnt/media/Music` → `$HOME/Music`
- `/mnt/media/Pictures` → `$HOME/Pictures`
- `/mnt/media/Videos` → `$HOME/Videos`

**Other Contents** (accessed via `/mnt/media/`):

- Code projects in `/mnt/media/Code`
- Random media collections
- Various personal files and archives

See [220_media_mount.md](220_media_mount.md) for detailed configuration.

## Mount Configuration

**Configuration Method**: `/etc/fstab` with UUID-based mounts

Mounts are configured in `/etc/fstab` using device UUIDs for stability:

- Games drive: UUID-based mount to `/games`
- Media drive: UUID-based mount to `/mnt/media`
- XDG directories: Bind mounts from `/mnt/media/*` to `~/*`

### fstab Configuration

```bash
# Games drive
UUID=<games-uuid>  /games  ext4  defaults  0  2

# Media drive (base mount)
UUID=<media-uuid>  /mnt/media  ntfs-3g  defaults,uid=1000,gid=1000,umask=0022  0  0

# Bind mounts for XDG directories
/mnt/media/Desktop    $HOME/Desktop    none  bind  0  0
/mnt/media/Documents  $HOME/Documents  none  bind  0  0
/mnt/media/Downloads  $HOME/Downloads  none  bind  0  0
/mnt/media/Music      $HOME/Music      none  bind  0  0
/mnt/media/Pictures   $HOME/Pictures   none  bind  0  0
/mnt/media/Videos     $HOME/Videos     none  bind  0  0
```

See [210_games_mount.md](210_games_mount.md) and [220_media_mount.md](220_media_mount.md) for detailed mount information.

## Related Documentation

- [210_games_mount.md](210_games_mount.md) - Games drive details
- [220_media_mount.md](220_media_mount.md) - Media drive details and XDG integration
- [500_configurations.md](500_configurations.md) - XDG user directories configuration
