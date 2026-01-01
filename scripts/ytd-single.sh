#!/bin/bash
# ytd-single.sh - Download a single YouTube video or audio

set -euo pipefail

# Get script directory for sourcing utils
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/ytd-utils.sh"

# Default values
music_mode="false"
open_folder_flag="false"
from_time=""
to_time=""
url=""

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -m)
            music_mode="true"
            shift
            ;;
        -v)
            music_mode="false"
            shift
            ;;
        -o|--open)
            open_folder_flag="true"
            shift
            ;;
        -from)
            from_time="$2"
            shift 2
            ;;
        -to)
            to_time="$2"
            shift 2
            ;;
        -*)
            echo -e "${COLOR_RED}Error: Unknown option: $1${COLOR_RESET}" >&2
            echo "Usage: ytd-single.sh [-m|-v] [-o|--open] [-from TIME] [-to TIME] URL" >&2
            exit 1
            ;;
        *)
            url="$1"
            shift
            ;;
    esac
done

# Validate URL
if [[ -z "$url" ]]; then
    echo -e "${COLOR_RED}Error: YouTube URL is required${COLOR_RESET}" >&2
    echo "Usage: ytd-single.sh [-m|-v] [-o|--open] [-from TIME] [-to TIME] URL" >&2
    exit 1
fi

# Check dependencies
require_ffmpeg="false"
if [[ "$music_mode" == "true" ]] || [[ -n "$from_time" ]] || [[ -n "$to_time" ]]; then
    require_ffmpeg="true"
fi

if ! test_dependencies "$require_ffmpeg"; then
    exit 1
fi

# Parse and validate time parameters
start_seconds=""
end_seconds=""
is_partial="false"

if [[ -n "$from_time" ]] || [[ -n "$to_time" ]]; then
    is_partial="true"
    
    if [[ -n "$from_time" ]]; then
        start_seconds=$(convert_to_seconds "$from_time")
        if [[ $? -ne 0 ]]; then
            exit 1
        fi
    fi
    
    if [[ -n "$to_time" ]]; then
        end_seconds=$(convert_to_seconds "$to_time")
        if [[ $? -ne 0 ]]; then
            exit 1
        fi
    fi
    
    # Validate from < to when both are specified
    if [[ -n "$start_seconds" ]] && [[ -n "$end_seconds" ]]; then
        if awk -v s="$start_seconds" -v e="$end_seconds" 'BEGIN { exit (s >= e) ? 0 : 1 }'; then
            echo -e "${COLOR_RED}Error: Invalid time range: -from ($from_time = ${start_seconds}s) must be less than -to ($to_time = ${end_seconds}s)${COLOR_RESET}" >&2
            exit 1
        fi
    fi
fi

# Initialize history
init_history

# Get output directory
base_output_dir=$(get_output_dir "$music_mode")

echo -e "${COLOR_YELLOW}Detected: Single video${COLOR_RESET}"
if [[ "$music_mode" == "true" ]]; then
    echo -e "${COLOR_CYAN}Mode: Audio only (Music)${COLOR_RESET}"
else
    echo -e "${COLOR_CYAN}Mode: Video${COLOR_RESET}"
fi

# Build yt-dlp arguments
mapfile -t ytdlp_args < <(get_ytdlp_args "$music_mode" "$base_output_dir")

# Handle time-based downloads
time_suffix=""
if [[ "$is_partial" == "true" ]]; then
    download_sections="*"
    
    if [[ -n "$start_seconds" ]] && [[ -n "$end_seconds" ]]; then
        download_sections="${start_seconds}-${end_seconds}"
        time_suffix=" $(format_time_suffix "$start_seconds" "$end_seconds")"
        echo -e "${COLOR_CYAN}Time range:${time_suffix}${COLOR_RESET}"
    elif [[ -n "$start_seconds" ]]; then
        download_sections="${start_seconds}-inf"
        echo -e "${COLOR_CYAN}Time range: from $from_time to end${COLOR_RESET}"
        time_suffix=" (from ${start_seconds}s)"
    elif [[ -n "$end_seconds" ]]; then
        download_sections="0-${end_seconds}"
        time_suffix=" $(format_time_suffix 0 "$end_seconds")"
        echo -e "${COLOR_CYAN}Time range:${time_suffix}${COLOR_RESET}"
    fi
    
    # Update output path to include time suffix
    for i in "${!ytdlp_args[@]}"; do
        if [[ "${ytdlp_args[$i]}" == "-o" ]] && [[ $((i + 1)) -lt ${#ytdlp_args[@]} ]]; then
            ytdlp_args[$((i + 1))]="${ytdlp_args[$((i + 1))]// \[%(id)s\].%(ext)s/${time_suffix} [%(id)s].%(ext)s}"
            break
        fi
    done
    
    ytdlp_args+=("--download-sections" "*${download_sections}")
    ytdlp_args+=("--force-keyframes-at-cuts")
fi

# Check history for full downloads
video_id=""
if [[ "$is_partial" == "false" ]]; then
    if [[ "$url" =~ v=([a-zA-Z0-9_-]{11}) ]]; then
        video_id="${BASH_REMATCH[1]}"
        
        if test_downloaded "$video_id"; then
            echo -e "${COLOR_YELLOW}This video was already downloaded.${COLOR_RESET}"
            read -p "Do you want to force re-download? (y/N) " response
            if [[ ! "$response" =~ ^[Yy]$ ]]; then
                echo -e "${COLOR_GRAY}Download cancelled.${COLOR_RESET}"
                exit 0
            fi
            echo -e "${COLOR_CYAN}Forcing re-download...${COLOR_RESET}"
        fi
    fi
fi

# Add URL to arguments
ytdlp_args+=("$url")

# Add quiet mode to suppress yt-dlp output
ytdlp_args+=("--quiet")
ytdlp_args+=("--progress")

# Execute download
echo -e "${COLOR_GREEN}Downloading from: $url${COLOR_RESET}"

# First, fetch video title for display
video_title=$(yt-dlp --skip-download --print "%(title)s" --no-warnings "$url" 2>/dev/null || echo "")
if [[ -n "$video_title" ]]; then
    echo -e "${COLOR_WHITE}Title: $video_title${COLOR_RESET}"
fi

echo -ne "${COLOR_CYAN}Downloading...${COLOR_RESET}"

# Run yt-dlp with output suppressed, capture stderr for errors
error_output=""
if ! error_output=$(yt-dlp "${ytdlp_args[@]}" 2>&1); then
    echo -e " ${COLOR_RED}Failed!${COLOR_RESET}"
    if [[ -n "$error_output" ]]; then
        echo -e "${COLOR_RED}Error: $error_output${COLOR_RESET}"
    fi
    exit 1
fi

echo -e " ${COLOR_GREEN}Done!${COLOR_RESET}"
echo -e "\n${COLOR_GREEN}Download completed successfully!${COLOR_RESET}"

# Add to history for full downloads only
if [[ "$is_partial" == "false" ]] && [[ -n "$video_id" ]]; then
    add_to_history "$video_id"
fi

# Open download folder if requested
if [[ "$open_folder_flag" == "true" ]]; then
    open_folder "$base_output_dir"
fi

exit 0
