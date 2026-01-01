# 540 - Audio Configuration

## Overview

This system uses PipeWire for audio routing with custom configurations to support switching between headset-only mode and surround sound mode (headset + TV/Sony AVSystem with 5.1 surround).

## Hardware Setup

### Audio Devices

- **Headset**: SteelSeries Arctis 7 (USB, stereo)
- **Surround System**: Sony AVSystem (5.1 surround speakers)
- **TV**: LG TV SSCR2 (HDMI audio passthrough)

### Audio Outputs Detected

1. **alsa_output.pci-0000_2d_00.1.hdmi-stereo** - Sony AVSystem / LG TV (Stereo)
2. **alsa_output.pci-0000_2d_00.1.hdmi-surround** - Sony AVSystem / LG TV (5.1 Surround) ✓ Used
3. **alsa_output.pci-0000_2d_00.1.hdmi-stereo-extra1** - CD240Q Monitor
4. **alsa_output.pci-0000_2d_00.1.hdmi-stereo-extra2** - BenQ XL2411Z Monitor
5. **alsa_output.pci-0000_2d_00.1.hdmi-stereo-extra3** - Odyssey G7 Monitor
6. **alsa_output.usb-SteelSeries_Arctis_7-00.stereo-game** - Headset ✓ Used

## Important: L/R Channel Swap

**The surround system's left and right channels are intentionally swapped** in the audio routing configuration.

**Reason**: The surround system is physically positioned for TV viewing (behind the user's chair). When using it with the PC, the user faces away from the speakers. Swapping the left and right channels makes sound appear to come from the correct direction relative to the PC user's position.

**Implementation**: Audio routing connects `monitor_FL → playback_FR` and `monitor_FR → playback_FL` instead of the normal FL→FL, FR→FR.

## Configuration Files

Configuration is done entirely through shell scripts using PipeWire/WirePlumber commands. No custom PipeWire configuration files are used.

### audio-aliases.sh

Defines shell aliases for convenient audio switching commands.

**Location**: `~/dev/scripts/audio-aliases.sh`
**Loaded by**: `~/.bashrc` (contains `source ~/dev/scripts/audio-aliases.sh`)

**Aliases defined:**

- `audio-surround` - Enable 5.1 surround sound mode
- `audio-headset` - Enable headset-only mode
- `audio-status` - Display current audio configuration

## Management Scripts

All scripts are located in `~/dev/scripts/`:

### audio-surround.sh

Activates surround sound configuration.

**Location**: `~/dev/scripts/audio-surround.sh`

**What it does:**

1. Switches HDMI audio card to 5.1 surround profile
2. Sets surround output volume to 100%
3. Creates PipeWire audio links with L/R channel swap
4. Connects audio to both headset and TV/surround system

**Usage:**

```bash
~/dev/scripts/audio-surround.sh
# or
audio-surround  # (if aliases are loaded)
```

### audio-headset-only.sh

Activates headset-only configuration.

**Location**: `~/dev/scripts/audio-headset-only.sh`

**What it does:**

1. Disconnects all HDMI audio connections
2. Verifies headset audio connections are active

**Usage:**

```bash
~/dev/scripts/audio-headset-only.sh
# or
audio-headset  # (if aliases are loaded)
```

### audio-status.sh

Displays current audio configuration and connection status.

**Location**: `~/dev/scripts/audio-status.sh`

**What it shows:**

- Active configuration file
- Currentmode (Surround or Headset-Only)e
- All active audio sinks
- HDMI audio connections
- Available management scripts

**Usage:**

```bash
~/dev/scripts/audio-status.sh
# or
audio-status  # (if aliases are loaded)
```

## Systemd User Service

A systemd user service automatically enables surround sound on login.

**Service File**: `~/dev/services/audio-surround.service`
**Symlink**: `~/.config/systemd/user/audio-surround.service`
**Status**: Enabled (runs on login)

### What It Does

The service:

1. Waits 2 seconds after login for PipeWire to be ready
2. Runs `audio-surround.sh` to configure 5.1 surround sound
3. Remains active until logout

This ensures surround sound is automatically configured every time you log in without manual intervention.

### Service Management

**Check service status:**

```bash
systemctl --user status audio-surround.service
```

**View service logs:**

```bash
journalctl --user -u audio-surround.service
```

**Disable autostart** (requires manual `audio-surround` after login):

```bash
systemctl --user disable audio-surround.service
```

**Re-enable autostart:**

```bash
systemctl --user enable audio-surround.service
```

**Manually start service** (without rebooting):

```bash
systemctl --user start audio-surround.service
```

## Audio Routing Flow

### Surround Sound Mode

```text
Application (Waterfox, games, etc.)
    ↓
PulseAudio/PipeWire Client
    ↓
Default Output (Gaming + Monitor) [virtual sink]
    ↓
    ├→ SteelSeries Arctis 7 Game (stereo)
    │    monitor_FL → playback_FL
    │    monitor_FR → playback_FR
    │
    └→ AD102 HDMI Surround 5.1 (with L/R swap)
         monitor_FL → playback_FR  (swapped!)
         monitor_FR → playback_FL  (swapped!)
         → LG TV → Sony AVSystem
```

### Headset-Only Mode

```text
Application (Waterfox, games, etc.)
    ↓
PulseAudio/PipeWire Client
    ↓
Default Output (Gaming + Monitor) [virtual sink]
    ↓
    └→ SteelSeries Arctis 7 Game (stereo)
         monitor_FL → playback_FL
         monitor_FR → playback_FR
```

## 5.1 Surround Channel Mapping

When in surround sound mode, the HDMI output provides 6 channels:

- **FL** - Front Left (swapped from FR due to positioning)
- **FR** - Front Right (swapped from FL due to positioning)
- **RL** - Rear Left (Side Left)
- **RR** - Rear Right (Side Right)
- **FC** - Front Center
- **LFE** - Low Frequency Effects (Subwoofer)

**Note**: Most applications output stereo (2 channels), so only the front-left and front-right speakers will play. Games and media players that support 5.1 surround will utilize all 6 channels.

## Quick Reference

### On Login

Surround sound is automatically enabled by the systemd service.

### Switch to Surround Sound

```bash
audio-surround
```

### Switch to Headset-Only

```bash
audio-headset
```

### Check Current Status

```bash
audio-status
```

## Troubleshooting

### No sound from TV/surround system

1. Verify TV is powered on
2. Check TV audio output settings:
   - Should be set to "HDMI-ARC" or "External Audio System"
   - NOT set to "TV Speakers"
3. Verify Sony AVSystem is:
   - Powered on
   - Set to the TV/ARC input
   - Volume is up and not muted
4. Check current configuration:

   ```bash
   audio-status
   ```

5. Re-run surround activation:

   ```bash
   audio-surround
   ```

### Sound only from headset

You may be in headset-only mode. Switch to surround:

```bash
audio-surround
```

### Left/Right channels are reversed

This is intentional! The swap compensates for the surround system's physical positioning. If you need to change it, edit the `pw-link` commands in `~/dev/scripts/audio-surround.sh` to connect FL→FL and FR→FR instead of the swapped configuration.

### Scripts don't exist or aren't executable

Ensure scripts have execute permissions:

```bash
chmod +x ~/dev/scripts/audio-*.sh
```

### Aliases not working

Ensure `~/.bashrc` contains the source line:

```bash
grep "audio-aliases.sh" ~/.bashrc
```

If not present, add it:

```bash
echo 'source ~/dev/configs/audio-aliases.sh' >> ~/.bashrc
```

Then reload your shell:

```bash
source ~/.bashrc
```

## Technical Details

### PipeWire vs PulseAudio

This system uses PipeWire, which is the modern replacement for PulseAudio. PipeWire provides:

- Lower latency
- Better Bluetooth support
- Pro audio capabilities
- Compatibility with PulseAudio applications

Commands like `pactl` are from PulseAudio but work with PipeWire through compatibility layers.

### WirePlumber

WirePlumber is the session manager for PipeWire. It handles automatic device detection and routing policies. Custom configurations are placed in:

```text
~/.config/wireplumber/wireplumber.conf.d/
```

The management scripts create a symlink at:

```text
~/.config/wireplumber/wireplumber.conf.d/99-custom-surround.conf
```

This symlink points to either `pipewire-surround.conf` or `pipewire-headset-only.conf` depending on the active mode.

### Audio Device Detection

HDMI audio devices only appear when the display is powered on and detected. This is why:

- The Sony AVSystem must be on for surround sound to work
- Different HDMI outputs appear/disappear based on connected displays
- Switching profiles may require the Sony AVSystem to be active

## Related Documentation

- [500_configurations.md](500_configurations.md) - System configuration overview
- [300_applications.md](300_applications.md) - Application configurations
