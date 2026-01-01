# 640 - i3 Autostart Configuration

## Overview

When i3 starts (via GDM/COSMIC login), several commands automatically execute in sequence to set up the desktop environment. These are defined in `~/.config/i3/config` as `exec --no-startup-id` directives.

## Autostart Command Sequence

### 1. Monitor Layout

```bash
exec --no-startup-id "~/dev/linux/scripts/monitor-layout.sh >> /tmp/i3-monitor-layout.log 2>&1"
```

**Purpose**: Configure multi-monitor setup with `xrandr`

**File**: [~/dev/linux/scripts/monitor-layout.sh](../../scripts/monitor-layout.sh)

**Configures**:

- DP-4 (left): 3840x2160 at position 0,0
- DP-3 (right): 1920x1080 at position 3840,0
- DP-1 (below-right): 2048x1152 at position 3840,1080
- HDMI-0: Mirrors DP-3

### 2. Xresources Configuration

```bash
exec --no-startup-id "xrdb -merge -I$HOME ~/.config/Xresources"
```

**Purpose**: Load terminal colors, fonts, and X11 appearance settings

**File**: `~/.config/Xresources`

**Configures**:

- urxvt terminal colors (16-color palette)
- Font: Monospace 24px
- Transparency: 35% shading
- Cursor: Underline, blinking

### 3. Wallpaper (Sleep 3s)

```bash
exec --no-startup-id "sh -c 'sleep 3; feh --bg-fill PATH/TO/WALLPAPER.png'"
```

**Purpose**: Set desktop wallpaper after monitors are configured

**Tool**: `feh` (lightweight image viewer)

**Options**:

- `--bg-fill`: Fills and crops the image to fit display without stretching
- Sleep 3s: Ensures monitor layout has fully applied before setting wallpaper

### 4. OpenTabletDriver Daemon

```bash
exec --no-startup-id "systemctl --user start opentabletdriver"
```

**Purpose**: Start OpenTabletDriver daemon for graphics tablet support

**Note**: The daemon is configured to auto-start via systemd, but this ensures it starts if not already running.

**Check Status**:

```bash
systemctl --user status opentabletdriver
```

### 5. Terminal Auto-Launch (Sleep 1s)

```bash
exec --no-startup-id "sh -c 'sleep 1; exec urxvt -geometry 120x40'"
for_window [class="URxvt"] move container to workspace $tag1
```

**Purpose**: Open initial terminal on workspace 1

**Configuration**:

- Geometry: 120 columns × 40 rows
- Auto-moves to workspace 1 ($tag1)

### 6. Messaging Applications (Sleep 2s)

```bash
exec --no-startup-id "sh -c 'sleep 2; exec flatpak run org.telegram.desktop'"
for_window [class="TelegramDesktop"] move container to workspace $tag6

exec --no-startup-id "sh -c 'sleep 2; exec signal-desktop'"
for_window [class="Signal"] move container to workspace $tag6

exec --no-startup-id "sh -c 'sleep 2; exec discord'"
for_window [class="discord"] move container to workspace $tag6
```

**Purpose**: Launch messaging apps to workspace 6 (Messengers)

**Applications**:

- Telegram (Flatpak)
- Signal (native)
- Discord (native)

### 7. Web Browser (Sleep 1s)

```bash
exec --no-startup-id "sh -c 'sleep 1; exec waterfox'"
for_window [class="Waterfox"] move container to workspace $tag2
```

**Purpose**: Open browser to workspace 2

**Application**: Waterfox (privacy-focused Firefox fork)

### 8. Code Editor (Sleep 2s)

```bash
exec --no-startup-id "sh -c 'sleep 2; exec code'"
for_window [class="Code"] move container to workspace $tag3
```

**Purpose**: Open VS Code to workspace 3 (Development)

### 9. GUI Editor (Sleep 3s)

```bash
exec --no-startup-id "sh -c 'sleep 3; exec mousepad /home/doubll/dev/i3/config'"
for_window [class="Mousepad"] move container to workspace 7
```

**Purpose**: Open i3 config file in GUI editor on workspace 7 (for quick editing)

**Application**: Mousepad (lightweight text editor)

### 10. Audio Routing (Sleep 4s)

```bash
exec --no-startup-id "sh -c 'sleep 4; exec qpwgraph -a -m ~/.config/qpwgraph/default.qpwgraph'"
```

**Purpose**: Launch audio routing tool with saved configuration

**Application**: QjackCtl/qpwgraph (PipeWire audio patchbay)

**Configuration**: `~/.config/qpwgraph/default.qpwgraph` (saved routing setup)


## Configuration File Locations

| Component | Config File |
| --------- | ----------- |
| i3 Config | `~/.config/i3/config` |
| Monitor Layout Script | `~/dev/linux/scripts/monitor-layout.sh` |
| Xresources | `~/.config/Xresources` |
| OpenTabletDriver | `~/.config/OpenTabletDriver/settings.json` |

## Modifying Autostart

To add or remove autostart commands:

1. Edit `~/.config/i3/config`
2. Add/modify `exec --no-startup-id` directives in the autostart section (lines ~110-150)
3. Reload i3 config: **Alt + Shift + C**

To test a single autostart command:

```bash
# Example: Test wallpaper setting
feh --bg-fill ~/Pictures/microsoft-windows-95.png
```

## Troubleshooting

### Application not starting on autostart

- Check if application is installed: `which appname`
- Verify window class with: `xdotool search --onlyvisible --class . getwindowname %@`
- Ensure `for_window` rule matches actual window class

### Wallpaper disappears after restart

- Check if `feh` is installed: `which feh`
- Verify image path exists: `ls ~/Pictures/microsoft-windows-95.png`
- Increase sleep delay if monitors aren't configured in time

### Xresources colors not applying to terminals

- Verify file exists: `cat ~/.config/Xresources`
- Check syntax: `xrdb -query | grep -i urxvt`
- Reload manually: `xrdb -merge -I$HOME ~/.config/Xresources`
- Restart terminal after reloading

## Related Documentation

- [620_i3.md](620_i3.md) - i3 window manager overview
- [630_i3_workspaces.md](630_i3_workspaces.md) - Workspace layout
- [310_opentabletdriver.md](310_opentabletdriver.md) - Tablet driver configuration
- [500_configurations.md](500_configurations.md) - System configurations
