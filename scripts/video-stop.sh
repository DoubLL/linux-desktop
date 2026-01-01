#!/bin/bash
# video-stop.sh - Stop all active ffmpeg screen recordings

# Check if ffmpeg is running
if ! pgrep -x ffmpeg >/dev/null; then
    notify-send "No Recording" "No active screen recording found" -i dialog-information 2>/dev/null || true
    exit 0
fi

# Send interrupt signal to all ffmpeg processes
killall -INT ffmpeg 2>/dev/null

# Notification is sent by video-start.sh when ffmpeg exits
# Just confirm the stop command was sent
notify-send "Stopping Recording" "Finalizing video file..." -i media-playback-stop 2>/dev/null || true