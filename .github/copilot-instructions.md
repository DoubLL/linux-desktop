# Copilot Instructions for Linux System Configuration Monorepo

## Purpose
This monorepo contains documentation, configuration files, and scripts for a Pop_OS system. It consolidates all custom system configurations, automation scripts, and documentation in one place for easy version control and reproducibility.

## Repository Structure

### `/notes/`
System documentation following a hierarchical numbering structure (similar to OneNote):
- **Main topics**: `XXX_name.md` (100, 200, 300, etc.)
- **Child pages**: `XX0_name.md` where first digit(s) match parent (210, 220 are children of 200)
- **Sub-child pages**: `XXX_name.md` where first two digits match parent (211, 212 are children of 210)
- **Special files**: `000_` prefix for index and meta-documentation

### `/i3/`
i3 window manager configuration files:
- `config` - Main i3 configuration
- Helper scripts for system integration (disk usage, monitor layout)
- Application-specific configurations (Signal Desktop)

### `/scripts/`
System automation and utility scripts:
- Audio management scripts (headset, surround sound, status)
- Bash aliases and helper functions

### `/services/`
Systemd service files for custom automation:
- Service definitions for scripts that should run automatically

## Documentation Principles

### What to Document
1. **Document only customizations**: Do not document default Pop_OS configurations or commonly pre-installed software
2. **Reproducibility**: Include installation commands and configuration snippets so the system can be recreated
3. **Absolute paths**: Always use absolute file paths when documenting configurations
4. **Cross-references**: Link between related documentation, scripts, and configuration files

### What NOT to Document
- Default Pop_OS configurations
- Pre-installed software behavior
- General Linux/Ubuntu documentation available elsewhere

### Parent-Child Documentation Pattern
- **Parent files** contain overviews and link to child pages
- **Child pages** contain specific details without duplicating parent content
- Keep the hierarchy visible in file numbering

## Current Documentation Topics

### Core System (000-199)
- **000_index.md**: Navigation hub with complete hierarchy tree
- **100_general.md**: General system overview, OS details, desktop environment

### Storage & Mounts (200-299)
- **200_storage.md**: Storage configuration overview
- **210_games_mount.md**: Secondary drive for Steam games
- **220_media_mount.md**: Large media drive with XDG directory redirects

### Applications (300-399)
- **300_applications.md**: Custom and manually installed applications
- **310_opentabletdriver.md**: Tablet driver configuration
- **320_rclone.md**: Cloud storage sync
- **330_gamingtools.md**: Gaming-related tools
- **340_waterfox.md**: Waterfox browser configuration

### Development (400-499)
- **400_development.md**: Development environment overview
- **410_python_setup.md**: Python environment details
- **420_project_locations.md**: Code project locations

### Configurations (500-599)
- **500_configurations.md**: System configuration files overview
- **510_xdg_directories.md**: Custom XDG directory configuration
- **520_cosmic_desktop.md**: COSMIC desktop environment settings
- **530_fan_control.md**: Fan control configuration
- **540_audio.md**: Audio system configuration

### Window Management (600-699)
- **600_window_management.md**: Window manager overview
- **610_cosmic.md**: COSMIC window management
- **620_i3.md**: i3 window manager configuration
- **630_i3_workspaces.md**: i3 workspace setup
- **631_messengers_workspace.md**: Dedicated messenger workspace configuration
- **640_i3_autostart.md**: i3 autostart applications

### TODO (900+)
- **900_TODO**: Pending tasks and future improvements

## Automatic Documentation Updates

When making system changes through this workspace, **automatically update relevant documentation and configuration files**:

### When Installing New Software
1. Add entry to [notes/300_applications.md](notes/300_applications.md)
2. Create child page `notes/3X0_appname.md` if configuration is complex
3. Include installation command, purpose, and configuration file locations
4. Update [notes/000_index.md](notes/000_index.md)

### When Modifying Storage/Mounts
1. Update [notes/200_storage.md](notes/200_storage.md) overview
2. Update or create relevant child page (210, 220, etc.)
3. Include mount commands, fstab entries, and usage information

### When Changing System Configurations
1. Update relevant documentation in [notes/500_configurations.md](notes/500_configurations.md) or appropriate child page
2. Add/update actual configuration files in appropriate directory (`i3/`, `scripts/`, etc.)
3. Note the absolute path and what was changed from default
4. Keep configuration files and documentation in sync

### When Setting Up Development Tools
1. Update [notes/400_development.md](notes/400_development.md)
2. Create child page for complex setups
3. Include version numbers, installation method, and configuration

### When Creating/Modifying Scripts
1. Add script to appropriate directory (`scripts/`, `i3/`)
2. Document in relevant notes file (usually 500-series or 600-series)
3. Include script purpose, location, usage, and any dependencies
4. If script needs systemd service, add to `services/` and document

### When Modifying i3 Configuration
1. Update files in `i3/` directory
2. Update [notes/620_i3.md](notes/620_i3.md) and relevant child pages
3. Document any new keybindings, workspaces, or autostart applications
4. Keep configuration and documentation synchronized

## File Location Guidelines

### Configuration Files
- **i3 configs**: `/i3/`
- **Systemd services**: `/services/`
- **Helper scripts**: `/scripts/`
- **Documentation**: `/notes/`

### System Integration
- When scripts are meant to be executed by the system, document the installation location (e.g., `~/.local/bin/`, `/usr/local/bin/`)
- When configuration files should be symlinked to system locations, document both the monorepo location and the target system path

## Update Workflow

1. **Before making system changes**: Check which files will need updates (both config and documentation)
2. **Make changes**: Update configuration files in appropriate directories
3. **Update documentation**: Synchronize relevant notes with the changes
4. **Update index**: Add new pages to [notes/000_index.md](notes/000_index.md) when created
5. **Cross-link**: Use markdown links to connect related documentation and reference actual config files in the monorepo

## Example Update Scenarios

### Scenario: User adds new i3 keybinding for audio control

1. Update [i3/config](i3/config): Add new keybinding
2. Possibly create script in [scripts/](scripts/) if needed
3. Update [notes/620_i3.md](notes/620_i3.md): Document the new keybinding
4. If audio-related, may also update [notes/540_audio.md](notes/540_audio.md)

### Scenario: User installs Docker

1. Update [notes/300_applications.md](notes/300_applications.md): Add Docker to application list
2. Create `notes/340_docker.md`: Document installation method, configuration
3. If Docker configs exist, consider adding them to a new `docker/` directory
4. Update [notes/000_index.md](notes/000_index.md): Add link to Docker documentation

### Scenario: User creates new systemd service for backup automation

1. Create service file in [services/backup.service](services/backup.service)
2. Create backup script in [scripts/backup.sh](scripts/backup.sh)
3. Update [notes/500_configurations.md](notes/500_configurations.md): Note the new service
4. Create `notes/540_backup.md`: Document service, script, schedule, and what it backs up
5. Update [notes/000_index.md](notes/000_index.md): Add link to backup documentation

### Scenario: User modifies audio switching scripts

1. Update script in [scripts/audio-*.sh](scripts/)
2. Update [notes/540_audio.md](notes/540_audio.md): Document changes to audio configuration
3. If systemd service affected, update [services/audio-surround.service](services/audio-surround.service)
4. Test and document any new audio profiles or behaviors

## Notes
- This monorepo approach allows version control of all system customizations in one place
- Configuration files in the repo can be symlinked to their system locations
- Documentation and actual configs should stay synchronized
- Focus on **what was changed from default Pop_OS** rather than documenting the OS itself
- When in doubt about whether to document something, ask: "Would I need this to reproduce my setup on a fresh install?"
