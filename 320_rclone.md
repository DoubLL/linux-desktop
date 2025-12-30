# 320 - rclone

## Overview

rclone is a command-line program for syncing files and directories to and from cloud storage providers including Google Drive, Dropbox, OneDrive, Amazon S3, and many others.

**Configured Remotes**: Google Drive (`GDrive`)  
**Mount Point**: `$HOME/gdrive`  
**Web GUI**: [http://localhost:5572/](http://localhost:5572/)

## Installation

**Installation Method**: APT package manager

```bash
sudo apt install rclone
```

## Configuration

### Initial Setup

Configure Google Drive access:

```bash
rclone config
```

Follow the interactive prompts:

1. Choose `n` (new remote)
2. Name it `GDrive` (or any name you prefer)
3. Choose `Google Drive` from the list
4. Follow browser authentication flow
5. Save configuration

**Important**: The initial setup downloads a client secret file to your home directory. This should be moved to a secure location:

```bash
# Client secret downloaded to:
~/client_secret_<app-id>.apps.googleusercontent.com.json

# Move to ~/.config/rclone/ or delete after setup completes
mv ~/client_secret_*.json ~/.config/rclone/
```

### Configuration Files

**Location**: `~/.config/rclone/rclone.conf`  
**Permissions**: `600` (rw------) - Encrypted/sensitive data

This file is **encrypted and contains sensitive information** including:

- Cloud storage remote configurations (e.g., `GDrive`)
- OAuth tokens and credentials
- Sync settings

**Security Note**: The file has appropriate restrictive permissions (600) to protect credentials.

## Configured Remotes

**Google Drive** (`GDrive`):

- **Mount Point**: `$HOME/gdrive` or `/home/<username>/gdrive`
- **Cache Mode**: `writes` (cache file writes for better performance)
- **Web Interface**: Enabled at [http://localhost:5572/](http://localhost:5572/)

## Mounting Google Drive

### Manual Mount

Mount Google Drive to local directory:

```bash
# Create mount point if it doesn't exist
mkdir -p $HOME/gdrive

# Mount with web GUI for monitoring
rclone mount GDrive: $HOME/gdrive --vfs-cache-mode writes --rc --rc-web-gui &
```

**Important Notes**:

- Use **full paths** (`/home/<username>/gdrive` or `$HOME/gdrive`) instead of `~/gdrive` - tilde expansion doesn't work in rclone mount commands
- The `--daemon` flag is **incompatible** with `--rc` (remote control) - use `&` to background instead
- Alternative: Use `nohup` to keep running after terminal close:

  ```bash
  nohup rclone mount GDrive: $HOME/gdrive --vfs-cache-mode writes --rc --rc-web-gui > ~/rclone.log 2>&1 &
  ```

### Unmounting

```bash
fusermount -u $HOME/gdrive

# Or if that fails:
sudo umount $HOME/gdrive
```

### Auto-Mount on Boot (systemd)

Create a systemd user service for automatic mounting:

```bash
mkdir -p ~/.config/systemd/user/
nano ~/.config/systemd/user/rclone-gdrive.service
```

**Service file contents**:

```ini
[Unit]
Description=RClone Google Drive Mount
After=network-online.target

[Service]
Type=simple
ExecStart=/usr/bin/rclone mount GDrive: %h/gdrive --vfs-cache-mode writes --rc --rc-web-gui
ExecStop=/bin/fusermount -u %h/gdrive
Restart=on-failure

[Install]
WantedBy=default.target
```

**Enable and start the service**:

```bash
systemctl --user daemon-reload
systemctl --user enable --now rclone-gdrive.service
```

**Check status**:

```bash
systemctl --user status rclone-gdrive.service
```

## Monitoring

### Web GUI

When mounted with `--rc --rc-web-gui`, access the web interface at:

**URL**: [http://localhost:5572/](http://localhost:5572/)

### Command-Line Monitoring

```bash
# Check mount status
mount | grep gdrive
df -h | grep gdrive

# View rclone stats (when --rc is enabled)
rclone rc core/stats
rclone rc core/transferred

# Check running processes
ps aux | grep rclone

# Kill rclone if needed
pkill rclone
```

## Usage

Common rclone commands:

```bash
# List configured remotes
rclone listremotes

# List files in remote
rclone ls GDrive:

# Sync local to remote (one-way)
rclone sync /local/path GDrive:path

# Bidirectional sync
rclone bisync /local/path GDrive:path

# Copy files (doesn't delete)
rclone copy /local/path GDrive:path

# Mount remote as filesystem (with web GUI)
rclone mount GDrive: $HOME/gdrive --vfs-cache-mode writes --rc --rc-web-gui &

# Check configuration
rclone config show

# Interactive config
rclone config
```

## Notes

- Use `--vfs-cache-mode writes` for better write performance
- Consider `--vfs-cache-mode full` for read-heavy workloads (uses more disk space)
- Monitor transfers via web GUI at [http://localhost:5572/](http://localhost:5572/)
- Use `--transfers` flag to adjust concurrent file transfers (default: 4)

## Related Documentation

- [300_applications.md](300_applications.md) - Custom applications overview
- [500_configurations.md](500_configurations.md) - System configuration files
