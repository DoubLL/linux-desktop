# Copilot Instructions for Pop_OS System Documentation

## Purpose
This workspace contains documentation about custom configurations and modifications made to this Pop_OS system. The documentation follows a hierarchical structure similar to OneNote, where main topics have numbered pages (100, 200, 300) and child pages provide additional details (110, 120, 210, etc.).

## File Naming Convention
- **Main topics**: `XXX_name.md` where XXX is a three-digit number (100, 200, 300, 400, 500, etc.)
- **Child pages**: `XX0_name.md` where the first digit(s) match the parent (e.g., 210, 220 are children of 200)
- **Sub-child pages**: `XXX_name.md` where first two digits match parent (e.g., 211, 212 are children of 210)
- **Special files**: `000_` prefix for index and meta-documentation

## Documentation Principles
1. **Document only customizations**: Do not document default Pop_OS configurations or commonly pre-installed software
2. **Parent-child relationship**: Parent files contain overviews and link to child pages; child pages contain specific details without duplicating parent content
3. **Keep it current**: Update relevant documentation whenever system changes are made through this workspace
4. **Absolute paths**: Always use absolute file paths when documenting configurations
5. **Command preservation**: Include installation commands and configuration snippets for reproducibility

## Current Documentation Structure

### 000_index.md
Navigation hub showing the complete hierarchy tree with descriptions and links to all documentation pages.

### 100_general.md
General system overview including:
- Pop_OS installation details
- Desktop environment (COSMIC)
- System-level customizations

### 200_storage.md
Storage configuration overview including:
- Custom drive mounts (/games, ~/media)
- Storage allocation and usage
- Links to child pages with mount details

**Child pages:**
- 210_games_mount.md - Details about /games mount (secondary drive for Steam)
- 220_media_mount.md - Details about ~/media mount (large media drive with XDG directory redirects)

### 300_applications.md
Custom and manually installed applications including:
- OpenTabletDriver
- rclone
- Sidekick browser
- Steam
- Other non-default software

**Child pages:**
- 310_opentabletdriver.md - Tablet driver configuration and settings
- 320_rclone.md - Cloud storage sync configuration
- 330_sidekick.md - Browser configuration and usage

### 400_development.md
Development environment overview including:
- Installed development tools (Python 3.13, Git 2.52)
- Development directory structure (~/dev, ~/media/Code)
- Version managers and language runtimes

**Child pages:**
- 410_python_setup.md - Python environment details
- 420_project_locations.md - Where code projects are stored

### 500_configurations.md
System configuration files and customizations including:
- XDG user directories pointing to ~/media
- Desktop environment settings
- Custom dotfiles

**Child pages:**
- 510_xdg_directories.md - Custom XDG directory configuration
- 520_cosmic_desktop.md - COSMIC desktop environment settings

## Automatic Documentation Updates

When making system changes through this workspace, **automatically update the relevant documentation files**:

### When Installing New Software
1. Add entry to [../300_applications.md](../300_applications.md) if the application is unusual or manually installed
2. Create child page `3X0_appname.md` if configuration is complex
3. Include installation command, purpose, and configuration file locations

### When Modifying Storage/Mounts
1. Update [../200_storage.md](../200_storage.md) overview if needed
2. Update or create relevant child page (210, 220, etc.)
3. Include mount commands, fstab entries, and usage information

### When Changing Configurations
1. Update [../500_configurations.md](../500_configurations.md)
2. Update or create child page with configuration file contents
3. Note the absolute path and what was changed from default

### When Setting Up Development Tools
1. Update [../400_development.md](../400_development.md)
2. Create child page for complex setups (language runtimes, IDEs, etc.)
3. Include version numbers, installation method, and configuration

### When Creating Custom Scripts
1. Document in [../400_development.md](../400_development.md) or [../500_configurations.md](../500_configurations.md) as appropriate
2. Include script location, purpose, and usage
3. Consider creating child page with full script content if complex

## Update Workflow

1. **Before making system changes**: Check which documentation files will need updates
2. **After making changes**: Update parent file overview and create/update child pages with details
3. **Keep 000_index.md current**: Add new pages to the index when created
4. **Link between pages**: Use markdown links to connect related documentation

## Example Update Scenarios

### Scenario: User installs Docker

1. Update [../300_applications.md](../300_applications.md): Add Docker to application list
2. Create `340_docker.md`: Document installation method, configuration files (`/etc/docker/daemon.json`), and any custom network/volume setups
3. Update [../000_index.md](../000_index.md): Add link to new Docker documentation

### Scenario: User creates a custom backup script

1. Update [../500_configurations.md](../500_configurations.md): Note the existence of custom backup automation
2. Create `530_backup_scripts.md`: Include full script, location (`~/.local/bin/backup.sh`), cron schedule, and what it backs up
3. Update [../000_index.md](../000_index.md): Add link to backup documentation

### Scenario: User mounts a new drive at /archive

1. Update [../200_storage.md](../200_storage.md): Add overview of new mount point
2. Create `230_archive_mount.md`: Include fstab entry, filesystem type, mount options, size, and purpose
3. Update [../000_index.md](../000_index.md): Add link to archive mount documentation

## Notes
- This documentation is for personal reference to remember system customizations
- Focus on **what was changed from default Pop_OS** rather than documenting the OS itself
- When in doubt about whether to document something, ask: "Would I need to remember this if I reinstalled the system?"
- Keep documentation concise but complete enough to reproduce the setup
