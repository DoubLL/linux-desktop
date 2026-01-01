# 100 - General System Overview

## Pop_OS Installation

- **OS**: Pop!_OS (System76's Ubuntu-based distribution)
- **Desktop Environment**: COSMIC (System76's custom desktop)

## Desktop Environment

Pop_OS uses the COSMIC desktop environment, which is System76's custom desktop built on top of GNOME technologies.

**Session Info:**

- Desktop Session: COSMIC
- XDG Desktop: COSMIC

## System Customizations

### Custom Storage Mounts

This system has two additional drives mounted for expanded storage:

- `/games` - ~2TB drive for Steam library (see [200_storage.md](200_storage.md))
- `~/media` - ~7TB drive for user files and projects (see [200_storage.md](200_storage.md))

### Custom Applications

Several applications have been manually installed beyond the default Pop_OS setup:

- OpenTabletDriver - for graphics tablet support
- rclone - for cloud storage synchronization
- Sidekick browser - alternative web browser
- Steam - gaming platform

See [300_applications.md](300_applications.md) for details.

### Development Environment

- Python 3.13.x
- Git 2.x
- Development directories: `~/dev` and `~/media/Code`

See [400_development.md](400_development.md) for details.

### Configuration Files

Custom configurations have been made to:

- XDG user directories (redirected to `~/media`)
- Desktop environment settings

See [500_configurations.md](500_configurations.md) for details.

## Related Documentation

- [200_storage.md](200_storage.md) - Storage and mount configurations
- [300_applications.md](300_applications.md) - Custom installed applications
- [400_development.md](400_development.md) - Development environment setup
- [500_configurations.md](500_configurations.md) - System configuration files
