# 400 - Development Environment

## Overview

This page documents the development tools and environment setup on this Pop_OS system, including installed languages, version managers, and project organization.

## Installed Development Tools

### Python

- **Version**: Python 3.13.x
- **Location**: `/usr/bin/python3`
- **Symlink**: `/usr/bin/python` → python3

**Note**: Python 3.13 is a recent version and may have been manually installed or updated beyond the default Pop_OS package.

See [410_python_setup.md](410_python_setup.md) for environment configuration details.

### Git

- **Version**: Git 2.x
- **Location**: `/usr/bin/git`

**Note**: Recent Git versions may be manually updated beyond the standard Pop_OS repository version.

### VS Code

- **Installation Method**: Flatpak (based on sandboxed path behavior)
- **Location**: `/app/bin/code`

Currently being used as the primary code editor for this documentation workspace.

## Project Organization

### Development Directories

#### ~/dev

Primary development workspace for local projects and documentation.

**Current Structure:**

- `~/dev/notes` - This documentation
- `~/dev/dev.code-workspace` - VS Code workspace file

#### ~/media/Code

Secondary development directory located on the large media drive.

**Purpose**: Long-term project storage and archive of various code projects.

**Current Projects:**

- Various Python scripts and utilities
- Web development projects
- Game development projects
- Personal tools and experiments

See [420_project_locations.md](420_project_locations.md) for detailed project inventory.

## Related Documentation

- [410_python_setup.md](410_python_setup.md) - Python environment and package management
- [420_project_locations.md](420_project_locations.md) - Code project inventory and locations
- [200_storage.md](200_storage.md) - Storage configuration for code directories
