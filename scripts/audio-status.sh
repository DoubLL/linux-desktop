#!/bin/bash
# Display current audio configuration status

echo "=== Current Audio Configuration ==="
echo ""

# Check if HDMI connections exist to determine mode
HDMI_CONNECTIONS=$(pw-link -l | grep -c "hdmi.*playback" || echo "0")
if [ "$HDMI_CONNECTIONS" -gt 0 ]; then
    echo "Active Mode: Surround Sound (headset + TV/5.1)"
else
    echo "Active Mode: Headset-Only"
fi

echo ""
echo "=== Audio Profile ==="
CARD_PROFILE=$(pactl list cards | grep -A 100 "alsa_card.pci-0000_2d_00.1" | grep "Active Profile:" | head -1 | awk -F: '{print $2}' | xargs)
echo "HDMI Profile: $CARD_PROFILE"

echo ""
echo "=== Active Audio Sinks ==="
pactl list sinks short | awk '{printf "  [%s] %s - %s\n", $1, $2, $6}'

echo ""
echo "=== HDMI Audio Connections ==="
pw-link -l | grep -B 1 "hdmi.*playback" | grep -E "default_output_sink|hdmi" || echo "  No HDMI connections"

echo ""
echo "=== Available Scripts ==="
echo "  ~/dev/scripts/audio-surround.sh     - Enable surround sound (headset + TV/5.1)"
echo "  ~/dev/scripts/audio-headset-only.sh - Enable headset only"
echo "  ~/dev/scripts/audio-status.sh       - Show this status"
echo ""
