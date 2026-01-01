#!/bin/bash
# screenshot-shutter.sh - Capture screenshots using shutter with optional instant-save

set -e

# Configuration
SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

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

# Build shutter command
shutter_args=()

case "$mode" in
    area)
        shutter_args+=("-s")
        ;;
    window)
        shutter_args+=("-a")  # Active window
        ;;
    fullscreen)
        shutter_args+=("-f")
        ;;
esac

# Add instant-save options if enabled
if [[ "$instant_save" == true ]]; then
    # Create directory if it doesn't exist
    mkdir -p "$SCREENSHOT_DIR"
    
    # Build filename
    filename="${SCREENSHOT_DIR}/screenshot_${mode}_${TIMESTAMP}.png"
    
    # Add shutter flags for instant-save
    shutter_args+=("-e")  # Exit after capture
    shutter_args+=("-n")  # No session
    shutter_args+=("-o" "$filename")  # Output file
    
    # Execute shutter
    shutter "${shutter_args[@]}" 2>/dev/null
    
    # Send notification
    notify-send "Screenshot Saved" "Screenshot saved to:\n${filename}" -i camera-photo
else
    # Normal mode - open shutter GUI
    shutter "${shutter_args[@]}" &
fi
