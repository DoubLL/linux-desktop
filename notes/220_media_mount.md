# 220 - Media Drive Mount

## Mount Point Details

- **Primary Mount Point**: `/mnt/media`
- **Device**: `/dev/sda2` (or similar large drive)
- **Filesystem**: NTFS (ntfs-3g driver)

## Bind Mounts to Home Directory

Instead of mounting the entire drive to `~/media`, individual directories are bind-mounted directly to standard home directory locations:

| Source (Media Drive) | Target (Home Dir) | Purpose |
| -------------------- | ----------------- | -------- |
| `/mnt/media/Desktop` | `$HOME/Desktop` | Desktop files |
| `/mnt/media/Documents` | `$HOME/Documents` | Documents |
| `/mnt/media/Downloads` | `$HOME/Downloads` | Downloads |
| `/mnt/media/Music` | `$HOME/Music` | Music library |
| `/mnt/media/Pictures` | `$HOME/Pictures` | Photos/images |
| `/mnt/media/Videos` | `$HOME/Videos` | Video files |

This eliminates the need for `~/media` as an intermediary and makes the directories accessible at their standard locations.

## Purpose

Large storage drive containing personal files, media, code projects, and XDG user directories. This drive appears to have been used previously on a Windows system and now serves as the primary data storage on this Pop_OS installation.

## Key Features

### XDG Directory Integration

Standard Linux user directories now use their default home directory locations via `~/.config/user-dirs.dirs`:

- Desktop → `$HOME/Desktop` (bind mount from `/mnt/media/Desktop`)
- Documents → `$HOME/Documents` (bind mount from `/mnt/media/Documents`)
- Downloads → `$HOME/Downloads` (bind mount from `/mnt/media/Downloads`)
- Pictures → `$HOME/Pictures` (bind mount from `/mnt/media/Pictures`)
- Videos → `$HOME/Videos` (bind mount from `/mnt/media/Videos`)
- Music → `$HOME/Music` (bind mount from `/mnt/media/Music`)

Applications see standard paths like `~/Music`, but the data is actually stored on the large media drive.

See [510_xdg_directories.md](510_xdg_directories.md) for the complete XDG configuration.

### Code Projects

- **Location**: `/mnt/media/Code`
- Contains various development projects including Python scripts, web projects, game development files
- Accessed via `/mnt/media/Code` (not bind-mounted to home directory)
- See [420_project_locations.md](420_project_locations.md) for project inventory

## Current Contents

### Major Directories

- `Desktop/` - Desktop files and shortcuts
- `Documents/` - Personal documents
- `Downloads/` - Downloaded files (XDG download directory)
- `Code/` - Development projects and code repositories
- Various media collections and personal files
- Archive files and backups

### Windows Artifacts

- `$RECYCLE.BIN/` - Windows recycle bin (can be ignored or deleted)
- NTFS filesystem with Windows-style permissions (rwxrwxrwx)

## Mount Configuration

**Configuration Method**: `/etc/fstab` with UUID-based mounting and bind mounts

### fstab Entries

#### Primary Mount

```bash
UUID=<uuid>  /mnt/media  ntfs-3g  defaults,uid=1000,gid=1000,umask=0022  0  0
```

**Mount Options**:

- `ntfs-3g`: NTFS driver for Linux
- `uid=1000,gid=1000`: Set ownership to primary user
- `umask=0022`: Set default permissions (755 for dirs, 644 for files)
- `0 0`: No dump, no fsck (not supported for NTFS)

#### Bind Mounts

```bash
/mnt/media/Desktop    $HOME/Desktop    none  bind  0  0
/mnt/media/Documents  $HOME/Documents  none  bind  0  0
/mnt/media/Downloads  /home/doubll/Downloads  none  bind  0  0
/mnt/media/Music      /home/doubll/Music      none  bind  0  0
/mnt/media/Pictures   /home/doubll/Pictures   none  bind  0  0
/mnt/media/Videos     /home/doubll/Videos     none  bind  0  0
```

### Installation Commands

The mounts were configured using:

```bash
# Mount media drive to /mnt/media
echo "UUID=$(sudo blkid -s UUID -o value /dev/sda2)  /mnt/media  ntfs-3g  defaults,uid=1000,gid=1000,umask=0022  0  0" | sudo tee -a /etc/fstab

# Add bind mounts for XDG directories
for dir in Desktop Documents Downloads Music Pictures Videos; do
  echo "/mnt/media/$dir  /home/doubll/$dir  none  bind  0  0" | sudo tee -a /etc/fstab
done
```

### NTFS Considerations

Since this is an NTFS filesystem:

- Requires `ntfs-3g` package for read/write access
- Permissions are controlled via mount options (uid, gid, umask)
- May have slightly reduced performance compared to native Linux filesystems
- Can still be accessed from Windows if dual-booting
- File attributes and extended permissions are limited

## Permissions

- **Owner**: doubll:doubll  
- **Mode**: drwxrwxrwx (777) - NTFS default permissions

## Related Documentation

- [200_storage.md](200_storage.md) - Overall storage configuration
- [510_xdg_directories.md](510_xdg_directories.md) - XDG user directories pointing to this drive
- [420_project_locations.md](420_project_locations.md) - Code project inventory in ~/media/Code
