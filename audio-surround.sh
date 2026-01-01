#!/bin/bash
# Switch to surround sound audio configuration
# Routes audio to both headset AND TV/Sony AVSystem with 5.1 surround

set -e

echo "=== Switching to Surround Sound Configuration ==="

# 1. Switch HDMI card to 5.1 surround profile
echo "→ Setting HDMI output to 5.1 surround..."
pactl set-card-profile alsa_card.pci-0000_2d_00.1 output:hdmi-surround

# Wait for profile to activate
sleep 1

# 2. Set volume to 100%
echo "→ Setting surround output volume to 100%..."
# Find the surround sink ID using wpctl (look for AD102 with Digital Surround and HDMI)
SURROUND_SINK=$(wpctl status | grep "AD102.*Digital Surround.*HDMI" | sed 's/[^0-9]*\([0-9]\+\).*/\1/')
if [ -n "$SURROUND_SINK" ]; then
    wpctl set-volume "$SURROUND_SINK" 100%
    echo "  Volume set for sink ID: $SURROUND_SINK"
else
    echo "Warning: Could not find surround sink, skipping volume setting"
fi

# 3. Create audio links with channel swapping
echo "→ Connecting audio with L/R channel swap for surround positioning..."

# Wait a moment for the sink to be ready
sleep 1

# Get the actual sink name for the surround output
SINK_NAME=$(pactl list sinks short | grep "hdmi-surround" | grep -v "extra" | awk '{print $2}')

if [ -n "$SINK_NAME" ]; then
    echo "  Using sink: $SINK_NAME"
    
    # Disconnect any existing HDMI connections first
    pw-link -d default_output_sink:monitor_FL "$SINK_NAME:playback_FL" 2>/dev/null || true
    pw-link -d default_output_sink:monitor_FR "$SINK_NAME:playback_FR" 2>/dev/null || true
    pw-link -d default_output_sink:monitor_FL "$SINK_NAME:playback_FR" 2>/dev/null || true
    pw-link -d default_output_sink:monitor_FR "$SINK_NAME:playback_FL" 2>/dev/null || true
    
    # Connect with swapped channels (FL→FR, FR→FL)
    # This is intentional: the surround system is behind the user
    echo "  Connecting FL → FR (swapped)"
    pw-link default_output_sink:monitor_FL "$SINK_NAME:playback_FR"
    echo "  Connecting FR → FL (swapped)"
    pw-link default_output_sink:monitor_FR "$SINK_NAME:playback_FL"
    
    echo "✓ Surround audio connections established"
else
    echo "Error: Could not find surround sink name"
    echo "Available HDMI sinks:"
    pactl list sinks short | grep hdmi
    exit 1
fi

echo ""
echo "=== Surround Sound Configuration Active ==="
echo "Audio is now routing to:"
echo "  - SteelSeries Arctis 7 headset (stereo)"
echo "  - LG TV → Sony AVSystem (5.1 surround with L/R swap)"
echo ""
