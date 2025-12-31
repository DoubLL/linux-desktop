# 630 - i3 Workspaces Layout

## Overview

i3 organizes work into numbered **workspaces** (virtual desktops). This system has 6 named workspaces pre-configured, each assigned to specific monitors.

## Workspace Layout

### Primary Monitor: DP-4 (3840×2160, 4K)

1: Terminal (`Alt+1`)
2: Waterfox (`Alt+2`)
3: Development (`Alt+3`)
4: Games (`Alt+4`)
5: Media (`Alt+5`)

### Secondary Monitor: DP-3 (1920×1080)

6: Messengers (`Alt+6`)

### Tablet Display: DP-1 (2560×1440)

7: Secondary Work Area (`Alt+7`)
8: Additional Applications (`Alt+8`)

## Switching Workspaces

**Quick Access:**

- `Alt+1` through `Alt+6` - Jump directly to workspace
- `Alt+X` - Next workspace (cycles through)
- `Alt+Y` - Previous workspace (cycles backward)

**Moving Windows:**

- `Alt+Shift+1` through `Alt+Shift+6` - Move focused window to workspace
- Window automatically appears on that workspace's assigned monitor

## Customizing Workspaces

### Add New Workspace

Edit `~/.config/i3/config`:

```bash
# Define new workspace
set $tag7 "My Custom Workspace"

# Optionally assign to monitor
workspace $tag7 output DP-1

# Add keyboard shortcuts
bindsym Mod1+7 workspace $tag7
bindsym Mod1+Shift+7 move container to workspace $tag7
```

Then reload config: `Alt+Shift+C`

### Rename Workspace

In i3, use: `Alt+Shift+N` to open a rename dialog for the current workspace.

### Change Monitor Assignment

Edit `~/.config/i3/config` and change the monitor output:

```bash
# Move workspace 2 from DP-3 to DP-1
workspace $tag2 output DP-1
```

Then reload: `Alt+Shift+C`

## Monitor Detection

i3 uses `xrandr` to detect monitors:

```bash
xrandr --listmonitors
```

## Related Documentation

- [600_window_management.md](600_window_management.md) - Desktop environment overview
- [620_i3.md](620_i3.md) - i3 keybindings and commands
- [631_messengers_workspace.md](631_messengers_workspace.md) - Messengers workspace details
