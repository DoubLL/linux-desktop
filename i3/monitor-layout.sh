#!/bin/bash
# Monitor layout script: 4K on left, 1080p on right, tablet below 1080p
# Wait for X11 to fully initialize
sleep 2

# Apply monitor layout
xrandr --output DP-4 --pos 0x0 \
        --output DP-3 --pos 3840x0 \
        --output DP-1 --pos 3840x1080 \
        --output HDMI-0 --off

# Log the result (optional, for debugging)
echo "Monitor layout applied at $(date)" >> ~/.xrandr-layout.log
xrandr --listmonitors >> ~/.xrandr-layout.log 2>&1
