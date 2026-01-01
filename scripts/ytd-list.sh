#!/bin/bash
# ytd-list.sh - Download a YouTube playlist

set -euo pipefail

# Get script directory for sourcing utils
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/ytd-utils.sh"

# Default values
music_mode="false"
open_folder_flag="false"
from_index=""
to_index=""
sort_order=""
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
            from_index="$2"
            shift 2
            ;;
        -to)
            to_index="$2"
            shift 2
            ;;
        -sort)
            sort_order="$2"
            shift 2
            ;;
        -*)
            echo -e "${COLOR_RED}Error: Unknown option: $1${COLOR_RESET}" >&2
            echo "Usage: ytd-list.sh [-m|-v] [-o|--open] [-from N] [-to N] [-sort asc|desc] URL" >&2
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
    echo -e "${COLOR_RED}Error: YouTube playlist URL is required${COLOR_RESET}" >&2
    echo "Usage: ytd-list.sh [-m|-v] [-o|--open] [-from N] [-to N] [-sort asc|desc] URL" >&2
    exit 1
fi

# Check dependencies
require_ffmpeg="$music_mode"
if ! test_dependencies "$require_ffmpeg"; then
    exit 1
fi

# Parse and validate index parameters
start_index=""
end_index=""

if [[ -n "$from_index" ]]; then
    if ! [[ "$from_index" =~ ^[0-9]+$ ]]; then
        echo -e "${COLOR_RED}Error: Invalid -from value: '$from_index'. Must be a positive integer (1-based index).${COLOR_RESET}" >&2
        exit 1
    fi
    start_index="$from_index"
    if [[ $start_index -lt 1 ]]; then
        echo -e "${COLOR_RED}Error: Invalid -from value: $start_index. Index must be at least 1.${COLOR_RESET}" >&2
        exit 1
    fi
fi

if [[ -n "$to_index" ]]; then
    if ! [[ "$to_index" =~ ^[0-9]+$ ]]; then
        echo -e "${COLOR_RED}Error: Invalid -to value: '$to_index'. Must be a positive integer (1-based index).${COLOR_RESET}" >&2
        exit 1
    fi
    end_index="$to_index"
    if [[ $end_index -lt 1 ]]; then
        echo -e "${COLOR_RED}Error: Invalid -to value: $end_index. Index must be at least 1.${COLOR_RESET}" >&2
        exit 1
    fi
fi

# Validate from <= to when both are specified
if [[ -n "$start_index" ]] && [[ -n "$end_index" ]]; then
    if [[ $start_index -gt $end_index ]]; then
        echo -e "${COLOR_RED}Error: Invalid index range: -from ($start_index) must be less than or equal to -to ($end_index).${COLOR_RESET}" >&2
        exit 1
    fi
fi

# Validate sort order
if [[ -n "$sort_order" ]] && [[ "$sort_order" != "asc" ]] && [[ "$sort_order" != "desc" ]]; then
    echo -e "${COLOR_RED}Error: Invalid -sort value: '$sort_order'. Must be 'asc' or 'desc'.${COLOR_RESET}" >&2
    exit 1
fi

# Initialize history and cache
init_history
init_cache

# Get output directory
base_output_dir=$(get_output_dir "$music_mode")

echo -e "${COLOR_YELLOW}Detected: Playlist${COLOR_RESET}"
if [[ "$music_mode" == "true" ]]; then
    echo -e "${COLOR_CYAN}Mode: Audio only (Music)${COLOR_RESET}"
else
    echo -e "${COLOR_CYAN}Mode: Video${COLOR_RESET}"
fi

# Fetch playlist video IDs (with upload dates if sorting)
echo -e "${COLOR_GRAY}Fetching playlist information...${COLOR_RESET}"

if [[ -n "$sort_order" ]]; then
    # Fetch video IDs using fast flat-playlist
    mapfile -t video_ids < <(yt-dlp --flat-playlist --print id "$url" 2>/dev/null)
    
    if [[ ${#video_ids[@]} -eq 0 ]]; then
        echo -e "${COLOR_RED}Error: Could not fetch playlist or playlist is empty.${COLOR_RESET}" >&2
        exit 1
    fi
    
    # Check which videos need upload date fetching (not in cache)
    uncached_ids=()
    cached_count=0
    for id in "${video_ids[@]}"; do
        cached_date=$(get_cached_date "$id")
        if [[ -z "$cached_date" ]]; then
            uncached_ids+=("$id")
        else
            ((cached_count++)) || true
        fi
    done
    
    if [[ $cached_count -gt 0 ]]; then
        echo -e "${COLOR_GRAY}Found $cached_count video(s) in upload date cache.${COLOR_RESET}"
    fi
    
    # Fetch upload dates for uncached videos
    if [[ ${#uncached_ids[@]} -gt 0 ]]; then
        echo -e "${COLOR_GRAY}Fetching upload dates for ${#uncached_ids[@]} uncached video(s)...${COLOR_RESET}"
        
        processed_count=0
        for id in "${uncached_ids[@]}"; do
            ((processed_count++)) || true
            echo -ne "\r${COLOR_GRAY}Fetching upload dates: ($processed_count/${#uncached_ids[@]})${COLOR_RESET}"
            
            upload_date=$(yt-dlp --skip-download --print "%(upload_date)s" --no-warnings "https://www.youtube.com/watch?v=$id" 2>/dev/null || echo "")
            
            if [[ -n "$upload_date" ]] && [[ "$upload_date" != "NA" ]]; then
                set_cached_date "$id" "$upload_date"
            fi
        done
        echo ""  # New line after progress
    fi
    
    # Build sorted list using cache
    declare -A video_dates
    for id in "${video_ids[@]}"; do
        date=$(get_cached_date "$id")
        if [[ -z "$date" ]]; then
            date="00000000"  # Default for missing dates
        fi
        video_dates[$id]="$date"
    done
    
    # Sort based on direction
    if [[ "$sort_order" == "asc" ]]; then
        mapfile -t sorted_ids < <(
            for id in "${video_ids[@]}"; do
                echo "${video_dates[$id]} $id"
            done | sort -k1,1 | cut -d' ' -f2
        )
        echo -e "${COLOR_CYAN}Sorting: oldest first (ascending by upload date)${COLOR_RESET}"
    else
        mapfile -t sorted_ids < <(
            for id in "${video_ids[@]}"; do
                echo "${video_dates[$id]} $id"
            done | sort -k1,1r | cut -d' ' -f2
        )
        echo -e "${COLOR_CYAN}Sorting: newest first (descending by upload date)${COLOR_RESET}"
    fi
    
    video_ids=("${sorted_ids[@]}")
else
    # No sorting - use playlist order (fast flat-playlist mode)
    mapfile -t video_ids < <(yt-dlp --flat-playlist --print id "$url" 2>/dev/null)
    
    if [[ ${#video_ids[@]} -eq 0 ]]; then
        echo -e "${COLOR_RED}Error: Could not fetch playlist or playlist is empty.${COLOR_RESET}" >&2
        exit 1
    fi
fi

total_videos=${#video_ids[@]}
echo -e "${COLOR_CYAN}Playlist contains $total_videos video(s).${COLOR_RESET}"

# Apply default index range if not specified
if [[ -z "$start_index" ]]; then
    start_index=1
fi
if [[ -z "$end_index" ]]; then
    end_index=$total_videos
fi

# Validate index range against playlist size
if [[ $start_index -gt $total_videos ]]; then
    echo -e "${COLOR_RED}Error: Invalid range: -from ($start_index) exceeds playlist size ($total_videos videos). No videos to download.${COLOR_RESET}" >&2
    exit 1
fi

if [[ $end_index -gt $total_videos ]]; then
    echo -e "${COLOR_YELLOW}Warning: -to ($end_index) exceeds playlist size ($total_videos videos).${COLOR_RESET}"
    read -p "Do you want to download videos $start_index to $total_videos instead? (y/N) " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        end_index=$total_videos
        echo -e "${COLOR_CYAN}Adjusted range: $start_index to $end_index${COLOR_RESET}"
    else
        echo -e "${COLOR_GRAY}Download cancelled.${COLOR_RESET}"
        exit 0
    fi
fi

echo -e "${COLOR_CYAN}Downloading videos $start_index to $end_index ($((end_index - start_index + 1)) videos)${COLOR_RESET}"

# Build index map and filter videos in range
videos_in_range=()
declare -A video_index_map

for i in "${!video_ids[@]}"; do
    index=$((i + 1))  # 1-based
    id="${video_ids[$i]}"
    video_index_map[$id]=$index
    
    if [[ $index -ge $start_index ]] && [[ $index -le $end_index ]]; then
        videos_in_range+=("$id")
    fi
done

# Check history and build download list
videos_to_download=()
skipped_videos=()
declare -A skipped_video_indices

for id in "${videos_in_range[@]}"; do
    index="${video_index_map[$id]}"
    if test_downloaded "$id"; then
        skipped_videos+=("$id")
        skipped_video_indices[$id]=$index
        echo -e "${COLOR_YELLOW}Skipping [$index] $id - already downloaded${COLOR_RESET}"
    else
        videos_to_download+=("$id")
    fi
done

# Handle all-skipped scenario
if [[ ${#videos_to_download[@]} -eq 0 ]] && [[ ${#skipped_videos[@]} -gt 0 ]]; then
    echo -e "\n${COLOR_YELLOW}All videos in range have already been downloaded.${COLOR_RESET}"
    read -p "Do you want to force re-download? (y/N) " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        videos_to_download=("${videos_in_range[@]}")
        skipped_videos=()
        unset skipped_video_indices
        declare -A skipped_video_indices
        echo -e "${COLOR_CYAN}Forcing re-download of all videos in range...${COLOR_RESET}"
    else
        echo -e "${COLOR_GRAY}Download cancelled.${COLOR_RESET}"
        exit 0
    fi
elif [[ ${#skipped_videos[@]} -gt 0 ]]; then
    echo -e "${COLOR_CYAN}${#skipped_videos[@]} video(s) skipped, ${#videos_to_download[@]} to download${COLOR_RESET}"
fi

# Get playlist title for subfolder
playlist_title=$(yt-dlp --flat-playlist --print playlist_title "$url" 2>/dev/null | head -n1)
if [[ -z "$playlist_title" ]]; then
    playlist_title="Unknown Playlist"
fi
output_dir="$base_output_dir/$playlist_title"

# Ensure playlist directory exists
mkdir -p "$output_dir"

# Build base yt-dlp arguments
mapfile -t base_args < <(get_ytdlp_args "$music_mode" "$output_dir")

echo -e "${COLOR_GREEN}Downloading from: $url${COLOR_RESET}"

# Download each video
download_success="true"

for id in "${videos_to_download[@]}"; do
    index="${video_index_map[$id]}"
    
    # Build args with index prefix in filename
    video_args=()
    for i in "${!base_args[@]}"; do
        if [[ "${base_args[$i]}" == "-o" ]] && [[ $((i + 1)) -lt ${#base_args[@]} ]]; then
            video_args+=("-o")
            output_template="${base_args[$((i + 1))]}"
            output_template="${output_template//%(title)s/[$index] %(title)s}"
            video_args+=("$output_template")
        else
            video_args+=("${base_args[$i]}")
        fi
    done
    video_args+=("https://www.youtube.com/watch?v=$id")
    
    # Add quiet mode
    video_args+=("--quiet")
    video_args+=("--progress")
    
    # Fetch video title for display
    video_title=$(yt-dlp --skip-download --print "%(title)s" --no-warnings "https://www.youtube.com/watch?v=$id" 2>/dev/null || echo "")
    
    echo -ne "\n${COLOR_CYAN}[$index/$total_videos] ${COLOR_RESET}"
    if [[ -n "$video_title" ]]; then
        # Truncate long titles
        if [[ ${#video_title} -gt 60 ]]; then
            video_title="${video_title:0:57}..."
        fi
        echo -e "${COLOR_WHITE}$video_title${COLOR_RESET}"
    else
        echo -e "${COLOR_WHITE}$id${COLOR_RESET}"
    fi
    
    echo -ne "${COLOR_GRAY}  Downloading...${COLOR_RESET}"
    
    # Run yt-dlp with output suppressed
    error_output=""
    if ! error_output=$(yt-dlp "${video_args[@]}" 2>&1); then
        echo -e " ${COLOR_RED}Failed!${COLOR_RESET}"
        if [[ -n "$error_output" ]]; then
            echo -e "${COLOR_RED}  Error: $error_output${COLOR_RESET}"
        fi
        download_success="false"
    else
        echo -e " ${COLOR_GREEN}Done!${COLOR_RESET}"
        add_to_history "$id"
    fi
done

# Offer to download skipped videos
if [[ ${#skipped_videos[@]} -gt 0 ]] && [[ "$download_success" == "true" ]]; then
    echo -e "\n${COLOR_YELLOW}${#skipped_videos[@]} video(s) were skipped because they were previously downloaded.${COLOR_RESET}"
    read -p "Do you want to force download the skipped videos? (y/N) " response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        echo -e "${COLOR_CYAN}Downloading skipped videos...${COLOR_RESET}"
        
        for id in "${skipped_videos[@]}"; do
            index="${skipped_video_indices[$id]}"
            
            video_args=()
            for i in "${!base_args[@]}"; do
                if [[ "${base_args[$i]}" == "-o" ]] && [[ $((i + 1)) -lt ${#base_args[@]} ]]; then
                    video_args+=("-o")
                    output_template="${base_args[$((i + 1))]}"
                    output_template="${output_template//%(title)s/[$index] %(title)s}"
                    video_args+=("$output_template")
                else
                    video_args+=("${base_args[$i]}")
                fi
            done
            video_args+=("https://www.youtube.com/watch?v=$id")
            video_args+=("--quiet")
            video_args+=("--progress")
            
            video_title=$(yt-dlp --skip-download --print "%(title)s" --no-warnings "https://www.youtube.com/watch?v=$id" 2>/dev/null || echo "")
            
            echo -ne "\n${COLOR_CYAN}[$index] ${COLOR_RESET}"
            if [[ -n "$video_title" ]]; then
                if [[ ${#video_title} -gt 60 ]]; then
                    video_title="${video_title:0:57}..."
                fi
                echo -e "${COLOR_WHITE}$video_title${COLOR_RESET}"
            else
                echo -e "${COLOR_WHITE}$id${COLOR_RESET}"
            fi
            
            echo -ne "${COLOR_GRAY}  Downloading...${COLOR_RESET}"
            
            error_output=""
            if ! error_output=$(yt-dlp "${video_args[@]}" 2>&1); then
                echo -e " ${COLOR_RED}Failed!${COLOR_RESET}"
                if [[ -n "$error_output" ]]; then
                    echo -e "${COLOR_RED}  Error: $error_output${COLOR_RESET}"
                fi
            else
                echo -e " ${COLOR_GREEN}Done!${COLOR_RESET}"
                add_to_history "$id"
            fi
        done
        echo -e "\n${COLOR_GREEN}Skipped videos download complete!${COLOR_RESET}"
    fi
fi

if [[ "$download_success" == "true" ]]; then
    echo -e "\n${COLOR_GREEN}Download completed successfully!${COLOR_RESET}"
    
    # Open download folder if requested
    if [[ "$open_folder_flag" == "true" ]]; then
        open_folder "$base_output_dir"
    fi
    
    exit 0
else
    echo -e "\n${COLOR_RED}Some downloads failed!${COLOR_RESET}"
    exit 1
fi
