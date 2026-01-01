#!/bin/bash
# ytd-download.sh - Download YouTube videos or playlists (auto-detect)

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Check if URL was provided
if [[ $# -eq 0 ]] || [[ "$1" == "-h" ]] || [[ "$1" == "--help" ]]; then
    echo "Usage: ytd [-m|-v] [-o|--open] [OPTIONS] URL"
    echo ""
    echo "Downloads YouTube videos or playlists."
    echo ""
    echo "Options:"
    echo "  -m              Download audio only (music mode)"
    echo "  -v              Download video (default)"
    echo "  -o, --open      Open download folder after completion"
    echo ""
    echo "Single video options:"
    echo "  -from TIME      Start time for clip (seconds, mm:ss, or hh:mm:ss)"
    echo "  -to TIME        End time for clip"
    echo ""
    echo "Playlist options:"
    echo "  -from N         Start index (1-based)"
    echo "  -to N           End index (1-based)"
    echo "  -sort asc|desc  Sort by upload date (oldest/newest first)"
    echo ""
    echo "Examples:"
    echo "  ytd 'https://www.youtube.com/watch?v=VIDEO_ID'"
    echo "  ytd -m 'https://www.youtube.com/watch?v=VIDEO_ID'"
    echo "  ytd -from 1:30 -to 3:45 'https://www.youtube.com/watch?v=VIDEO_ID'"
    echo "  ytd 'https://www.youtube.com/playlist?list=PLAYLIST_ID'"
    echo "  ytd -m -from 5 -to 12 'https://www.youtube.com/playlist?list=PLAYLIST_ID'"
    echo "  ytd -sort desc 'https://www.youtube.com/playlist?list=PLAYLIST_ID'"
    exit 0
fi

# Find URL in arguments
url=""
for arg in "$@"; do
    if [[ "$arg" =~ ^https?:// ]]; then
        url="$arg"
        break
    fi
done

if [[ -z "$url" ]]; then
    echo "Error: No YouTube URL provided" >&2
    echo "Usage: ytd [-m|-v] [-o|--open] [OPTIONS] URL" >&2
    exit 1
fi

# Detect if URL is a playlist
if [[ "$url" =~ list= ]]; then
    # Delegate to playlist script
    exec "$SCRIPT_DIR/ytd-list.sh" "$@"
else
    # Delegate to single video script
    exec "$SCRIPT_DIR/ytd-single.sh" "$@"
fi
