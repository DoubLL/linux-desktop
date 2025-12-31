#!/bin/sh

# Merge Xresources
if [ -f ~/.Xresources ]; then
    xrdb -merge -I$HOME ~/.Xresources
fi

# Apply monitor layout
if [ -f ~/.local/bin/monitor-layout.sh ]; then
    sh ~/.local/bin/monitor-layout.sh
fi

# Start PipeWire if not already running
if [ -z "$(pgrep -u $USER pipewire)" ]; then
    pipewire &
fi

# Set wallpaper
feh --bg-scale ~/Pictures/microsoft-windows-95.png &

exec i3
