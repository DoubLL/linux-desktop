#!/bin/bash
# ytd-utils.sh - Shared utilities for YouTube download scripts

# ANSI color codes
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_CYAN='\033[0;36m'
readonly COLOR_GRAY='\033[0;90m'
readonly COLOR_WHITE='\033[0;97m'
readonly COLOR_RESET='\033[0m'

# History and cache file locations
readonly HISTORY_DIR="$HOME/.local/share/ytd"
readonly HISTORY_FILE="$HISTORY_DIR/download-history.txt"
readonly CACHE_FILE="$HISTORY_DIR/upload-date-cache.txt"

# Convert time string to seconds
# Supports: seconds only (e.g., "90" or "90.5"), mm:ss (e.g., "1:30.5"), or hh:mm:ss (e.g., "0:01:30.5")
convert_to_seconds() {
    local time_string="$1"
    
    if [[ -z "$time_string" ]]; then
        echo ""
        return
    fi
    
    # Check if it's just a number (seconds only, with optional decimal)
    if [[ "$time_string" =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
        echo "$time_string"
        return
    fi
    
    # Support both mm:ss and hh:mm:ss formats (with optional decimal on seconds)
    IFS=':' read -ra parts <<< "$time_string"
    
    if [[ ${#parts[@]} -eq 2 ]]; then
        # mm:ss format
        local minutes="${parts[0]}"
        local seconds="${parts[1]}"
        awk -v m="$minutes" -v s="$seconds" 'BEGIN { printf "%.2f", (m * 60) + s }'
    elif [[ ${#parts[@]} -eq 3 ]]; then
        # hh:mm:ss format
        local hours="${parts[0]}"
        local minutes="${parts[1]}"
        local seconds="${parts[2]}"
        awk -v h="$hours" -v m="$minutes" -v s="$seconds" 'BEGIN { printf "%.2f", (h * 3600) + (m * 60) + s }'
    else
        echo -e "${COLOR_RED}Error: Invalid time format: $time_string. Use seconds (e.g., 90 or 90.5), mm:ss, or hh:mm:ss format.${COLOR_RESET}" >&2
        return 1
    fi
}

# Format time suffix as "(Xs from YminZs)"
format_time_suffix() {
    local start_seconds="$1"
    local end_seconds="$2"
    
    local duration
    duration=$(awk -v e="$end_seconds" -v s="$start_seconds" 'BEGIN { printf "%.1f", e - s }')
    
    local start_min
    start_min=$(awk -v s="$start_seconds" 'BEGIN { printf "%d", int(s / 60) }')
    
    local start_sec
    start_sec=$(awk -v s="$start_seconds" -v m="$start_min" 'BEGIN { printf "%.1f", s - (m * 60) }')
    
    # Remove trailing .0 for cleaner output
    duration="${duration%.0}"
    start_sec="${start_sec%.0}"
    
    echo "(${duration}s from ${start_min}min${start_sec}s)"
}

# Initialize history file
init_history() {
    if [[ ! -d "$HISTORY_DIR" ]]; then
        mkdir -p "$HISTORY_DIR"
    fi
    
    if [[ ! -f "$HISTORY_FILE" ]]; then
        touch "$HISTORY_FILE"
    fi
}

# Check if video was already downloaded
test_downloaded() {
    local video_id="$1"
    
    if [[ ! -f "$HISTORY_FILE" ]]; then
        return 1
    fi
    
    grep -qxF "$video_id" "$HISTORY_FILE"
}

# Add video ID to history file
add_to_history() {
    local video_id="$1"
    echo "$video_id" >> "$HISTORY_FILE"
}

# Initialize upload date cache
init_cache() {
    if [[ ! -d "$HISTORY_DIR" ]]; then
        mkdir -p "$HISTORY_DIR"
    fi
    
    if [[ ! -f "$CACHE_FILE" ]]; then
        touch "$CACHE_FILE"
    fi
}

# Get cached upload date for a video ID
get_cached_date() {
    local video_id="$1"
    
    if [[ ! -f "$CACHE_FILE" ]]; then
        echo ""
        return
    fi
    
    grep "^${video_id}|" "$CACHE_FILE" | cut -d'|' -f2
}

# Add or update upload date in cache file
set_cached_date() {
    local video_id="$1"
    local upload_date="$2"
    
    # Only add if not already cached
    if ! grep -q "^${video_id}|" "$CACHE_FILE" 2>/dev/null; then
        echo "${video_id}|${upload_date}" >> "$CACHE_FILE"
    fi
}

# Check for required dependencies
test_dependencies() {
    local require_ffmpeg="$1"
    
    if ! command -v yt-dlp >/dev/null 2>&1; then
        echo -e "${COLOR_RED}Error: yt-dlp is not installed or not in PATH.${COLOR_RESET}" >&2
        echo -e "${COLOR_YELLOW}Install it with: sudo apt install yt-dlp${COLOR_RESET}" >&2
        return 1
    fi
    
    if [[ "$require_ffmpeg" == "true" ]]; then
        if ! command -v ffmpeg >/dev/null 2>&1; then
            echo -e "${COLOR_RED}Error: ffmpeg is not installed or not in PATH.${COLOR_RESET}" >&2
            echo -e "${COLOR_YELLOW}It's required for time-based downloads and audio extraction.${COLOR_RESET}" >&2
            echo -e "${COLOR_YELLOW}Install it with: sudo apt install ffmpeg${COLOR_RESET}" >&2
            return 1
        fi
    fi
    
    return 0
}

# Build base yt-dlp arguments for audio or video mode
get_ytdlp_args() {
    local music_mode="$1"
    local output_dir="$2"
    
    local args=()
    
    if [[ "$music_mode" == "true" ]]; then
        args+=("-x")
        args+=("--audio-format" "mp3")
        args+=("--audio-quality" "0")
        args+=("--embed-metadata")
        args+=("--embed-thumbnail")
        args+=("-o" "${output_dir}/%(title)s [%(id)s].%(ext)s")
    else
        args+=("-f" "bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best")
        args+=("-o" "${output_dir}/%(title)s [%(id)s].%(ext)s")
        args+=("--embed-metadata")
    fi
    
    printf '%s\n' "${args[@]}"
}

# Open download folder in file manager
open_folder() {
    local folder="$1"
    
    if command -v xdg-open >/dev/null 2>&1; then
        xdg-open "$folder" >/dev/null 2>&1 &
    else
        echo -e "${COLOR_YELLOW}Warning: xdg-open not available, cannot open folder${COLOR_RESET}" >&2
    fi
}

# Get output directory based on mode
get_output_dir() {
    local music_mode="$1"
    
    if [[ "$music_mode" == "true" ]]; then
        echo "$HOME/Music"
    else
        echo "$HOME/Videos"
    fi
}
