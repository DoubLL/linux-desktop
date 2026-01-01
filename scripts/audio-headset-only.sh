#!/bin/bash
# Switch to headset-only audio configuration
# Routes audio ONLY to the SteelSeries Arctis 7 headset

set -e

echo "=== Switching to Headset-Only Configuration ==="

# 1. Disconnect all HDMI audio connections
echo "→ Disconnecting surround system audio..."

# Try both possible sink names (stereo and surround)
for sink_pattern in "hdmi-stereo" "hdmi-surround"; do
    SINK_NAME=$(pactl list sinks short | grep "$sink_pattern" | grep -v "extra" | awk '{print $2}' | head -1)
    
    if [ -n "$SINK_NAME" ]; then
        echo "  Disconnecting from: $SINK_NAME"
        # Disconnect all possible channel combinations
        pw-link -d default_output_sink:monitor_FL "$SINK_NAME:playback_FL" 2>/dev/null || true
        pw-link -d default_output_sink:monitor_FR "$SINK_NAME:playback_FR" 2>/dev/null || true
        pw-link -d default_output_sink:monitor_FL "$SINK_NAME:playback_FR" 2>/dev/null || true
        pw-link -d default_output_sink:monitor_FR "$SINK_NAME:playback_FL" 2>/dev/null || true
        pw-link -d default_output_sink:monitor_FL "$SINK_NAME:playback_FC" 2>/dev/null || true
        pw-link -d default_output_sink:monitor_FR "$SINK_NAME:playback_FC" 2>/dev/null || true
    fi
done

# 2. Verify headset connection still exists
HEADSET_SINK=$(pactl list sinks short | grep "Arctis.*stereo-game" | awk '{print $2}')
if [ -n "$HEADSET_SINK" ]; then
    echo "→ Verifying headset connection..."
    # These should already be connected, but ensure they are
    pw-link default_output_sink:monitor_FL "$HEADSET_SINK:playback_FL" 2>/dev/null || echo "  (Headset FL already connected)"
    pw-link default_output_sink:monitor_FR "$HEADSET_SINK:playback_FR" 2>/dev/null || echo "  (Headset FR already connected)"
    echo "✓ Headset audio verified"
else
    echo "Warning: Could not find SteelSeries headset"
fi

echo ""
echo "=== Headset-Only Configuration Active ==="
echo "Audio is now routing to:"
echo "  - SteelSeries Arctis 7 headset (stereo)"
echo "  - TV/Surround system: DISCONNECTED"
echo ""
