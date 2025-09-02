#!/usr/bin/env bash

# ytdl-music.sh - Download music from YouTube with proper metadata

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Default download directory (change this to your preference)
DOWNLOAD_DIR="$HOME/Music/Music/New"

print_usage() {
    echo -e "${BLUE}Usage:${NC}"
    echo "  $0 [OPTIONS] [URL]"
    echo ""
    echo -e "${BLUE}Options:${NC}"
    echo "  -d, --dir DIR     Download directory (default: $DOWNLOAD_DIR)"
    echo "  -h, --help        Show this help message"
    echo ""
    echo -e "${BLUE}Examples:${NC}"
    echo "  $0                                    # Interactive mode"
    echo "  $0 https://youtu.be/..."             # Direct download"
    echo "  $0 -d ~/Downloads https://youtu.be/..."
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dir)
            DOWNLOAD_DIR="$2"
            shift 2
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        -*)
            echo -e "${RED}Error: Unknown option $1${NC}"
            print_usage
            exit 1
            ;;
        *)
            URL="$1"
            shift
            ;;
    esac
done

# Create download directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Get URL if not provided
if [[ -z "$URL" ]]; then
    echo -e "${BLUE}Enter YouTube URL (video or playlist):${NC}"
    read -r URL
fi

# Validate URL
if [[ -z "$URL" ]]; then
    echo -e "${RED}Error: No URL provided${NC}"
    exit 1
fi

if [[ ! "$URL" =~ ^https?://(www\.)?(youtube\.com|youtu\.be) ]]; then
    echo -e "${YELLOW}Warning: This doesn't look like a YouTube URL${NC}"
    echo -e "${BLUE}Continue anyway? (y/N):${NC}"
    read -r confirm
    if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
        echo "Cancelled."
        exit 0
    fi
fi

# Use the same output template for both playlists and single videos
# This will put everything directly in the New folder without subdirectories
OUTPUT_TEMPLATE="$DOWNLOAD_DIR/%(title)s.%(ext)s"

# Check if it's a playlist for informational purposes
if [[ "$URL" =~ list= ]]; then
    echo -e "${GREEN}Detected playlist - downloading all songs to New folder...${NC}"
else
    echo -e "${GREEN}Detected single video - downloading to New folder...${NC}"
fi

echo -e "${BLUE}Downloading to: $DOWNLOAD_DIR${NC}"
echo -e "${BLUE}Starting download...${NC}"

# Build the command - simplified to avoid subdirectories
cmd="yt-dlp \
    --extract-audio \
    --audio-format mp3 \
    --audio-quality 0 \
    --embed-thumbnail \
    --add-metadata \
    --parse-metadata \"%(uploader)s:%(artist)s\" \
    --parse-metadata \"%(title)s:%(track)s\" \
    --output \"$OUTPUT_TEMPLATE\" \
    --extractor-args \"youtube:player_client=android\" \
    --no-overwrites \
    \"$URL\""

# Execute the command
eval $cmd

# Check if download was successful
if [[ $? -eq 0 ]]; then
    echo -e "${GREEN}✓ Download completed successfully!${NC}"
    
    # Check if MPD is running and offer to update database
    if pgrep -x "mpd" > /dev/null; then
        echo -e "${BLUE}MPD detected. Update music database? (Y/n):${NC}"
        read -r update_mpd
        if [[ ! "$update_mpd" =~ ^[Nn]$ ]]; then
            if command -v mpc &> /dev/null; then
                echo -e "${BLUE}Updating MPD database...${NC}"
                mpc update
                echo -e "${GREEN}✓ MPD database updated!${NC}"
            else
                echo -e "${YELLOW}mpc command not found. Please update MPD database manually.${NC}"
            fi
        fi
    fi
    
    echo -e "${GREEN}Files saved to: $DOWNLOAD_DIR${NC}"
else
    echo -e "${RED}✗ Download failed!${NC}"
    exit 1
fi
