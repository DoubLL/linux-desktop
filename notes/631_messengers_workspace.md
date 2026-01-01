# 631 - Messengers Workspace (i3)

## Overview

The **Messengers workspace** (Workspace 6, Alt+6) is dedicated to communication applications on the secondary 1080p monitor (DP-2).

Three applications autostart and automatically move to this workspace:

- **Telegram** (`org.telegram.desktop`)
- **Signal** (`org.signal.Signal`)
- **Discord** (`com.discordapp.Discord`)

## Setup

### Autostart Configuration

In `~/.config/i3/config`:

```bash
# Messaging apps - autostart to Messengers workspace (DP-2)
exec --no-startup-id "sh -c 'sleep 2; exec flatpak run org.telegram.desktop'"
for_window [class="TelegramDesktop"] move container to workspace $tag6

exec --no-startup-id "sh -c 'sleep 2; exec flatpak run org.signal.Signal'"
for_window [class="Signal"] move container to workspace $tag6

exec --no-startup-id "sh -c 'sleep 2; exec flatpak run com.discordapp.Discord'"
for_window [class="discord"] move container to workspace $tag6
```

**What happens:**

1. On i3 startup, each app launches with a 2-second delay (prevents startup race conditions)
2. Window matching rules intercept each app's window
3. `move container to workspace $tag6` automatically sends it to Messengers workspace
4. All three apps appear together on DP-2 monitor

### Workspace Assignment

```bash
# Messengers workspace assigned to secondary monitor
set $tag6 "&#xf1d9; Messengers"
workspace $tag6 output DP-2
```

**Result:** Whenever you switch to workspace 6 (Alt+6), DP-2 shows all messaging apps.

## Usage

### Quick Access

- **Alt + 6** - View all messengers at once
- Apps appear on DP-2 (secondary monitor)
- Your work remains on DP-3 (primary monitor)

### Manual Window Arrangement (Optional)

If you want to tile/arrange the three windows specifically:

```bash
# After opening all three, Alt+6 to focus messengers
# Then arrange with splits:
Alt+H                # Split horizontally
                     # Windows now arrange vertically
Alt+V                # Split vertically
                     # Windows arrange side-by-side
Alt+S                # Stack layout (tabs)
Alt+W                # Tabbed layout
Alt+E                # Toggle between arrangements
```

**Default tiling:** i3 automatically tiles them based on open order. Typical result:

- Telegram on top-left
- Signal on bottom-left
- Discord on right side

(Exact arrangement depends on which app opened first and your split configuration.)

### Hiding Messengers

To minimize distractions, you can hide messengers while working:

- Switch to different workspace: **Alt+1** through **Alt+5**
- Messengers still running in background on DP-2
- Switch back: **Alt+6**

### Launching Individual Apps

From anywhere:

- **Super + T** - Launch Telegram
- **Super + S** - Launch Signal
- **Super + D** - Launch Discord

(These may open on current workspace or pop up on DP-2 if already running.)

## Configuration File Locations

**Main config:**
- `~/.config/i3/config` (symlinked from `~/dev/i3/config`)

**Status bar:**
- `~/.config/i3blocks/config` (displays workspace names/icons in top bar)

## Editing and Testing

### Modify Autostart Apps

Edit `~/.config/i3/config`:

```bash
# Example: Change Telegram to Signal as first app
exec --no-startup-id "sh -c 'sleep 1; exec flatpak run org.signal.Signal'"
for_window [class="Signal"] move container to workspace $tag6
```

Then reload: **Alt + Shift + C**

### Check if Apps are Running

```bash
pgrep -l 'telegram\|signal\|discord'
```

### View Open Windows

```bash
wmctrl -l
```

Shows all windows and their workspace assignments.

### Debug Autostart

If apps aren't moving to workspace:
1. Launch one app manually: `Super+T`
2. Check i3 logs (check i3's stderr output when starting)
3. Verify window class matches config:
   ```bash
   xdotool search --name "Telegram" getwindowfocus getwindowname
   ```
4. Update `for_window [class="..."]` rule if needed

## Common Customizations

### Change Delay Time
Increase the 2-second delay if apps aren't starting in time:
```bash
exec --no-startup-id "sh -c 'sleep 4; exec flatpak run org.telegram.desktop'"
```

### Add More Apps
Add to autostart section:
```bash
exec --no-startup-id "sh -c 'sleep 2; exec myapp'"
for_window [class="MyApp"] move container to workspace $tag6
```

### Assign to Different Monitor/Workspace
Change the target workspace:
```bash
for_window [class="TelegramDesktop"] move container to workspace $tag5
```

Then reload: **Alt + Shift + C**

### Autostart on Different Workspaces
If you want each app on its own workspace:
```bash
# Telegram on workspace 6
for_window [class="TelegramDesktop"] move container to workspace $tag6

# Signal on workspace 7
exec --no-startup-id "sh -c 'sleep 3; exec flatpak run org.signal.Signal'"
for_window [class="Signal"] move container to workspace 7

# Discord on workspace 8
exec --no-startup-id "sh -c 'sleep 4; exec flatpak run com.discordapp.Discord'"
for_window [class="discord"] move container to workspace 8
```

Then update workspace definitions:
```bash
set $tag7 "Signal"
set $tag8 "Discord"
workspace $tag7 output DP-2
workspace $tag8 output DP-2
```

## Related Documentation

- [630_i3_workspaces.md](630_i3_workspaces.md) - All workspaces overview
- [620_i3.md](620_i3.md) - i3 keybindings and usage
- [600_window_management.md](600_window_management.md) - Desktop environment comparison
- [660_messengers_workspace.md](660_messengers_workspace.md) - COSMIC messengers setup (alternative)
