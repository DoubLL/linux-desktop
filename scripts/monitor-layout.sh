#!/bin/bash
# Monitor layout script: 4K on left, 1080p on right, tablet below 1080p

xrandr --output DP-4 --auto --primary --pos 0x0 \
        --output DP-3 --auto --pos 3840x0 \
        --output DP-1 --auto --pos 3840x1080 \
        --output HDMI-0 --mode 1920x1080 --same-as DP-3

# Log the result (optional, for debugging)
echo "Monitor layout applied at $(date)" >> ~/.xrandr-layout.log
xrandr --listmonitors >> ~/.xrandr-layout.log 2>&1
