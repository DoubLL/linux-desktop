# 410 - Python Setup

## Python Installation

### Version

- **Python Version**: 3.13.x
- **Release**: Python 3.13 series (recent major release)

### Installation Locations

- **Python 3**: `/usr/bin/python3`
- **Python Symlink**: `/usr/bin/python` → `/usr/bin/python3`

### Installation Method

Python 3.13.x is quite recent and likely installed through:

- Manual build from source
- Third-party PPA or repository
- Official Python downloads
- **Not from default Pop_OS repositories** (which typically provide older Python 3.x versions)

## Package Management

### pip

Standard Python package manager should be available as:

- `pip3` or `pip` (verify with `which pip pip3`)

### Virtual Environments

Check if any virtual environment tools are installed:

- `venv` (built-in to Python 3.13)
- `virtualenv`
- `pipenv`
- `poetry`

**To be documented**: Run `which virtualenv pipenv poetry` to check for additional tools.

## Python Projects

### Current Projects

Based on the system audit, Python code exists in:

- `~/media/Code/` - Various Python scripts and utilities

See [420_project_locations.md](420_project_locations.md) for complete project inventory.

## System Python vs User Python

**Important**: As this is a newer Python version, consider:

- Whether this is the system Python (used by system tools)
- If system scripts depend on an older Python version
- Using virtual environments for project-specific dependencies

## To Document Further

The following should be investigated and documented:

1. How Python 3.13 was installed (source, PPA, or binary)
2. Installed Python packages: `pip list`
3. Virtual environment setup (if any)
4. Any system conflicts with older Python versions
5. pip configuration file locations (`~/.config/pip/`, `~/.pip/`)

## Related Documentation

- [400_development.md](400_development.md) - Development environment overview
- [420_project_locations.md](420_project_locations.md) - Python project locations
