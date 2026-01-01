#!/bin/bash
# video-start.sh - Start screen recording with ffmpeg and audio capture

# Configuration
VIDEO_DIR="$HOME/Videos/Recordings"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
FRAMERATE=30
CRF=23  # Balanced quality

# Parse arguments
mode=""
instant_save=false

while [[ $# -gt 0 ]]; do
    case $1 in
        area|window|fullscreen)
            mode="$1"
            shift
            ;;
        --instant-save)
            instant_save=true
            shift
            ;;
        *)
            echo "Error: Unknown argument: $1" >&2
            echo "Usage: $0 {area|window|fullscreen} [--instant-save]" >&2
            exit 1
            ;;
    esac
done

# Validate mode
if [[ -z "$mode" ]]; then
    echo "Error: No mode specified" >&2
    echo "Usage: $0 {area|window|fullscreen} [--instant-save]" >&2
    exit 1
fi

# Create output directory
mkdir -p "$VIDEO_DIR"

# Build output filename
output_file="${VIDEO_DIR}/recording_${mode}_${TIMESTAMP}.mp4"

# Get recording parameters based on mode
case "$mode" in
    area)
        # Use slop for area selection
        read -r X Y W H < <(slop -f "%x %y %w %h" 2>/dev/null)
        # Check if we got valid coordinates (slop can exit 1 due to compositor warning but still work)
        if [[ -z "$W" || -z "$H" ]]; then
            notify-send "Recording Cancelled" "Area selection was cancelled" -i dialog-error 2>/dev/null || true
            exit 1
        fi
        # Round dimensions to even numbers (required for H.264 encoding)
        W=$(( (W / 2) * 2 ))
        H=$(( (H / 2) * 2 ))
        video_size="${W}x${H}"
        offset="+${X},${Y}"
        notify_msg="Recording area ${W}x${H} at position ${X},${Y}"
        ;;
    window)
        # Get active window geometry using xdotool
        if ! command -v xdotool &>/dev/null; then
            notify-send "Error" "xdotool is not installed.\nRun: sudo apt install xdotool" -i dialog-error 2>/dev/null || true
            exit 1
        fi
        eval $(xdotool getactivewindow getwindowgeometry --shell)
        # Round dimensions to even numbers (required for H.264 encoding)
        WIDTH=$(( (WIDTH / 2) * 2 ))
        HEIGHT=$(( (HEIGHT / 2) * 2 ))
        video_size="${WIDTH}x${HEIGHT}"
        offset="+${X},${Y}"
        notify_msg="Recording window ${WIDTH}x${HEIGHT}"
        ;;
    fullscreen)
        # Get screen resolution
        screen_info=$(xrandr | grep -w connected | grep -oP '\d+x\d+\+\d+\+\d+' | head -n 1)
        video_size=$(echo "$screen_info" | cut -d+ -f1)
        offset_x=$(echo "$screen_info" | cut -d+ -f2)
        offset_y=$(echo "$screen_info" | cut -d+ -f3)
        offset="+${offset_x},${offset_y}"
        notify_msg="Recording full screen ${video_size}"
        ;;
esac

# Start recording in background
{
    ffmpeg -f x11grab -framerate "$FRAMERATE" -video_size "$video_size" -i "${DISPLAY}${offset}" \
           -f pulse -i default \
           -c:v libx264 -preset ultrafast -crf "$CRF" -pix_fmt yuv420p \
           -c:a aac -b:a 128k \
           "$output_file" \
           >/dev/null 2>&1
    
    # When ffmpeg stops, send completion notification
    notify-send "Recording Stopped" "Video saved to:\n${output_file}" -i video-x-generic 2>/dev/null || true
} &

# Send start notification
notify-send "Recording Started" "${notify_msg}\n\nPress Mod4+Esc to stop" -i media-record 2>/dev/null || true
