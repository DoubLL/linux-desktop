# 350 - YouTube Download Tools

## Overview

Command-line tools for downloading YouTube videos and playlists with support for audio-only extraction, time-based clipping, playlist filtering, and upload date sorting.

## Installation

**yt-dlp** must be installed from the latest GitHub release due to YouTube's frequently changing API. The Ubuntu repository version is outdated and will fail with 403 errors.

```bash
# Install ffmpeg from apt
sudo apt install ffmpeg

# Download and install latest yt-dlp binary
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
sudo chmod a+rx /usr/local/bin/yt-dlp

# Verify installation
yt-dlp --version
```

**To update yt-dlp later:**

```bash
# yt-dlp has built-in self-update
sudo yt-dlp -U
```

**Components**:

- **yt-dlp** - YouTube downloader (`/usr/local/bin/yt-dlp`)
- **ffmpeg** - Media processing for audio extraction and time-based clipping (`/usr/bin/ffmpeg`)

## Script Locations

All scripts are located in `~/dev/linux/scripts/`:

- `ytd-download.sh` - Main wrapper (auto-detects single video vs playlist)
- `ytd-single.sh` - Single video downloads with time clipping
- `ytd-list.sh` - Playlist downloads with range filtering and sorting
- `ytd-utils.sh` - Shared utility functions
- `ytd-aliases.sh` - Bash alias definitions

## Aliases

Aliases are loaded automatically via `~/.bashrc`:

```bash
ytd           # Auto-detect single video or playlist
ytd-single    # Force single video mode
ytd-list      # Force playlist mode
```

## Output Directories

**Video Downloads**: `~/Videos/`

- Single videos: `~/Videos/Title [ID].mp4`
- Playlists: `~/Videos/PlaylistName/[1] Title [ID].mp4`

**Music Downloads** (with `-m` flag): `~/Music/`

- Single audio: `~/Music/Title [ID].mp3`
- Playlists: `~/Music/PlaylistName/[1] Title [ID].mp3`

## Usage

### Basic Usage

**Download a single video:**

```bash
ytd 'https://www.youtube.com/watch?v=VIDEO_ID'
```

**Download audio only (music mode):**

```bash
ytd -m 'https://www.youtube.com/watch?v=VIDEO_ID'
```

**Download an entire playlist:**

```bash
ytd 'https://www.youtube.com/playlist?list=PLAYLIST_ID'
```

**Download playlist as audio:**

```bash
ytd -m 'https://www.youtube.com/playlist?list=PLAYLIST_ID'
```

### Time-Based Clipping (Single Videos)

Extract specific time ranges from videos using `-from` and `-to` flags.

**Supported time formats:**

- Seconds: `90` or `90.5`
- Minutes:Seconds: `1:30` or `1:30.5`
- Hours:Minutes:Seconds: `1:30:45` or `1:30:45.5`

**Examples:**

```bash
# Download from 1:30 to 3:45
ytd -from 1:30 -to 3:45 'https://www.youtube.com/watch?v=VIDEO_ID'

# Download from start to 2:00
ytd -to 2:00 'https://www.youtube.com/watch?v=VIDEO_ID'

# Download from 30 seconds to end
ytd -from 30 'https://www.youtube.com/watch?v=VIDEO_ID'

# Download audio clip from 1 minute to 2 minutes
ytd -m -from 1:00 -to 2:00 'https://www.youtube.com/watch?v=VIDEO_ID'
```

**Output filename includes time info:**
```
Title (45s from 1min30s) [ID].mp4
```

### Playlist Range Filtering

Download specific videos from a playlist using 1-based index ranges.

**Download videos 5 through 12:**

```bash
ytd-list -from 5 -to 12 'https://www.youtube.com/playlist?list=PLAYLIST_ID'
```

**Download first 10 videos:**

```bash
ytd-list -to 10 'https://www.youtube.com/playlist?list=PLAYLIST_ID'
```

**Download from video 20 to end:**

```bash
ytd-list -from 20 'https://www.youtube.com/playlist?list=PLAYLIST_ID'
```

### Upload Date Sorting

Sort playlist videos by upload date before applying range filters.

**Download newest 5 videos:**

```bash
ytd-list -sort desc -to 5 'https://www.youtube.com/playlist?list=PLAYLIST_ID'
```

**Download oldest 10 videos:**

```bash
ytd-list -sort asc -to 10 'https://www.youtube.com/playlist?list=PLAYLIST_ID'
```

**Upload date caching**: Upload dates are cached in `~/.local/share/ytd/upload-date-cache.txt` to avoid repeated API calls on subsequent runs.

### Opening Download Folder

Use `-o` or `--open` to open the download folder in your file manager after completion:

```bash
ytd -o 'https://www.youtube.com/watch?v=VIDEO_ID'
ytd-list -o -m 'https://www.youtube.com/playlist?list=PLAYLIST_ID'
```

Opens the folder using `xdg-open` (respects your default file manager).

## Download History

**Location**: `~/.local/share/ytd/download-history.txt`

Tracks downloaded video IDs to prevent duplicate downloads.

**Behavior:**

- Full video downloads are recorded in history
- Partial clips (time-based) bypass history tracking
- Already-downloaded videos prompt for re-download confirmation
- Skipped videos can be force-downloaded after main download completes

**Manually clear history:**

```bash
rm ~/.local/share/ytd/download-history.txt
```

## Upload Date Cache

**Location**: `~/.local/share/ytd/upload-date-cache.txt`

Caches video upload dates to speed up sorting operations.

**Format**: `VideoID|YYYYMMDD` (one per line)

**Manually clear cache:**

```bash
rm ~/.local/share/ytd/upload-date-cache.txt
```

## Advanced Examples

**Download playlist sorted by date, range 10-20, as audio, open folder:**

```bash
ytd-list -m -o -sort desc -from 10 -to 20 'https://www.youtube.com/playlist?list=PLAYLIST_ID'
```

**Download specific music segment from video:**

```bash
ytd -m -from 2:15 -to 5:30 'https://www.youtube.com/watch?v=VIDEO_ID'
```

**Download only new videos from a playlist:**

```bash
# First run downloads all videos and tracks them
ytd-list 'https://www.youtube.com/playlist?list=PLAYLIST_ID'

# Subsequent runs skip already-downloaded videos
ytd-list 'https://www.youtube.com/playlist?list=PLAYLIST_ID'
```

## Audio Quality

Music mode (`-m`) downloads highest quality audio and converts to MP3 with:

- Best audio quality (320kbps equivalent)
- Embedded metadata (title, artist, album, etc.)
- Embedded thumbnail as album art

## Video Quality

Video mode (default) downloads:

- Best quality MP4 video + audio
- Embedded metadata
- Preference for H.264 video codec (better compatibility)

## Troubleshooting

### Dependencies Not Found

If you see "yt-dlp is not installed" or "ffmpeg is not installed":

```bash
sudo apt install yt-dlp ffmpeg
```

### Aliases Not Working

Ensure `~/.bashrc` contains:

```bash
source ~/dev/linux/scripts/ytd-aliases.sh
```

Reload your shell:

```bash
source ~/.bashrc
```

Or open a new terminal.

### Permission Denied

Ensure scripts are executable:

```bash
chmod +x ~/dev/linux/scripts/ytd-*.sh
```

### Download Fails

**Age-restricted videos**: yt-dlp may not be able to download age-restricted content without authentication.

**Geo-blocked videos**: Some videos are restricted by region.

**Private or deleted videos**: Cannot be downloaded.

**Playlist videos unavailable**: The script will skip unavailable videos and continue with the rest.

## Related Documentation

- [300_applications.md](300_applications.md) - Application installation overview
- [200_storage.md](200_storage.md) - Storage configuration (~/Videos and ~/Music mount points)

## Script Details

### ytd-download.sh

Main entry point. Auto-detects single video or playlist by checking for `list=` in URL, then delegates to appropriate specialized script.

### ytd-single.sh

Single video downloads with optional time-based clipping.

**Parameters:**

- `-m` - Music mode (audio only)
- `-v` - Video mode (default)
- `-o` / `--open` - Open download folder
- `-from TIME` - Start time (seconds, mm:ss, hh:mm:ss)
- `-to TIME` - End time

**Features:**

- History check for full downloads only
- Interactive re-download prompt
- Time suffix in filename for clips
- Video title display during download

### ytd-list.sh

Playlist downloads with range filtering and sorting.

**Parameters:**

- `-m` - Music mode (audio only)
- `-v` - Video mode (default)
- `-o` / `--open` - Open download folder
- `-from N` - Start index (1-based)
- `-to N` - End index (1-based, inclusive)
- `-sort asc|desc` - Sort by upload date

**Features:**

- Playlist index prefixing: `[1] Title.mp4`, `[2] Title.mp4`, etc.
- Upload date caching to avoid repeated API calls
- History tracking per video
- Interactive re-download for skipped videos
- Per-video progress display with titles

### ytd-utils.sh

Shared utility library providing:

- Time string parsing and conversion
- History file management
- Upload date cache management
- Dependency checking
- Output directory resolution
- yt-dlp argument construction
- File manager integration
- ANSI color code definitions

## Notes

- Playlist downloads can take significant time depending on playlist size
- Upload date fetching requires one API call per uncached video
- Large playlists benefit from upload date caching on subsequent runs
- Scripts are designed to be non-interactive when possible (quiet mode with progress)
- All downloads preserve video metadata when possible
