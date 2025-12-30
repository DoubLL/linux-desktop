# 310 - OpenTabletDriver

## Overview

OpenTabletDriver is an open-source, cross-platform graphics tablet driver that provides support for various drawing tablets on Linux, including the XP-Pen Artist 24.

**Tablet Model**: XP-Pen Artist 24 (24 inch PenDisplay)  
**USB IDs**: VendorID `28bd` (10429), ProductID `093a` (2362)

## Installation

**Installation Method**: Manual installation from GitHub releases + source build

### Quick Installation Steps

1 **Install .NET Runtime 6.0 first**:

```bash
wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt update
sudo apt install dotnet-runtime-6.0
```

2 **Download and install OpenTabletDriver**:

```bash
cd ~/Downloads
wget https://github.com/OpenTabletDriver/OpenTabletDriver/releases/download/v0.6.4.0/OpenTabletDriver.deb
sudo apt install ./OpenTabletDriver.deb
```

3 **Add udev rules for XP-Pen Artist 24**:

```bash
sudo nano /etc/udev/rules.d/99-opentabletdriver.rules
```

Add these lines:

```bash
# XP-Pen Artist 24
SUBSYSTEM=="usb", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="093a", MODE="0666"
SUBSYSTEM=="hidraw", ATTRS{idVendor}=="28bd", ATTRS{idProduct}=="093a", MODE="0666"
```

Reload udev rules:

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

4 **Clone repo and copy tablet configurations** (missing from .deb package):

```bash
cd ~/Downloads
git clone --depth 1 --branch 0.6.x https://github.com/OpenTabletDriver/OpenTabletDriver.git
sudo mkdir -p /usr/lib/opentabletdriver/configurations
sudo cp -r ~/Downloads/OpenTabletDriver/OpenTabletDriver.Configurations/Configurations/* /usr/lib/opentabletdriver/configurations/
```

Verify Artist 24 config exists:

```bash
ls /usr/lib/opentabletdriver/configurations/XP-Pen/ | grep "Artist 24"
# Should show: Artist 24.json, Artist 24 Pro.json
```

5 **If building from source is needed** (for version mismatch):

```bash
cd ~/Downloads/OpenTabletDriver
sudo apt install dotnet-sdk-8.0  # Required for build
git tag v0.6.4.0  # Add tag to shallow clone
./eng/bash/package.sh --package Debian
sudo apt install ./dist/opentabletdriver*.deb
```

6 **Start the driver**:

```bash
systemctl --user daemon-reload
systemctl --user enable --now opentabletdriver.service
otd-gui
```

## Configuration

**Configuration Location**: `~/.config/OpenTabletDriver/settings.json`

### GUI Configuration

Launch the GUI with:

```bash
otd-gui
```

**Key Settings**:

- **Output Tab**: Map display to the 1440p XP-Pen monitor
- **Pen Settings**: Adjust pressure curve as needed
- **Bindings**: Configure express keys/buttons

### Tablet Detection

Check if tablet is detected:

```bash
lsusb | grep -i xp-pen
# Should show: Bus XXX Device XXX: ID 28bd:093a XP-Pen 24 inch PenDisplay
```

Check driver logs:

```bash
journalctl --user -u opentabletdriver.service -f
```

Successful detection shows:

```bash
[Detect:Debug] Searching for tablet 'XP-Pen Artist 24'
[Detect:Info]  Tablet detected: XP-Pen Artist 24
```

## Troubleshooting

### Tablet Not Detected

**Issue**: "No tablets were detected"

**Common Causes**:

1. Missing udev rules - add rules and unplug/replug tablet
2. Configurations folder missing - manually copy from GitHub repo
3. Version mismatch between daemon and configs - rebuild from source

**Debug Commands**:

```bash
# Check USB connection
lsusb | grep 28bd

# Check service status
systemctl --user status opentabletdriver.service

# View live logs
journalctl --user -u opentabletdriver.service -f

# Verify config file exists and is valid
cat /usr/lib/opentabletdriver/configurations/XP-Pen/Artist\ 24.json
python3 -m json.tool /usr/lib/opentabletdriver/configurations/XP-Pen/Artist\ 24.json
```

### .deb Package Limitations

The prebuilt .deb package from GitHub has issues:

- **Missing configurations folder** - must be manually copied from source
- **Embedded old configs** - daemon may not search for newer tablet definitions
- **Solution**: Build from source or manually add configurations

## Alternative: XP-Pen Official Driver

If OpenTabletDriver causes issues, XP-Pen provides an official Linux driver:

```bash
cd ~/Downloads
wget https://www.xp-pen.com/upload/download/20231010/Linux_Pentablet_V3.5.1.231010.tar.gz
tar -xzf Linux_Pentablet_V3.5.1.231010.tar.gz
cd Linux_Pentablet_V3.5.1.231010
sudo sh install.sh
pentabletdriver
```

**Note**: Check [XP-Pen's website](https://www.xp-pen.com/product/1197.html) for the latest driver version.

## Related Documentation

- [300_applications.md](300_applications.md) - Custom applications overview
- [500_configurations.md](500_configurations.md) - System configurations
