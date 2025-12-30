# 210 - Games Drive Mount

## Mount Point Details

- **Mount Point**: `/games`
- **Device**: `/dev/sdb1` (or similar secondary drive)
- **Filesystem**: ext4

## Purpose

Dedicated storage for game installations, primarily for the Steam gaming platform. Separating game storage from the system drive helps:

- Preserve system SSD space and performance
- Organize large game files separately
- Easier backup/restore of game library

## Current Contents

### Directory Structure

```text
/games/
├── lost+found/         # Filesystem recovery directory
└── Steam/              # Steam installation and library
```

### Steam Library

The Steam client and all game installations are stored on this drive:

- **Location**: `/games/Steam`

## Mount Configuration

**Configuration Method**: `/etc/fstab` with UUID-based mounting

### fstab Entry

```bash
UUID=<uuid>  /games  ext4  defaults  0  2
```

**Mount Options**:

- `defaults`: Standard mount options (rw, suid, dev, exec, auto, nouser, async)
- `0`: No dump backup
- `2`: Filesystem check order (after root filesystem)

### Installation Command

The mount was configured using:

```bash
echo "UUID=$(sudo blkid -s UUID -o value /dev/sdb1)  /games  ext4  defaults  0  2" | sudo tee -a /etc/fstab
sudo mount /games
```

### Persistence

Mount persists across reboots via `/etc/fstab`. The UUID-based identification ensures the drive is correctly identified even if device names change.

## Permissions

- **Owner**: user:user
- **Mode**: drwxr-xr-x (755)

## Related Documentation

- [200_storage.md](200_storage.md) - Overall storage configuration
- [300_applications.md](300_applications.md) - Steam application details
