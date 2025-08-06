#!/bin/bash

# Media Wake Guard - Prevents display sleep and system suspend when media is playing
# Supports Firefox, Chrome/Chromium, VLC, and Spotify

# Configuration
CHECK_INTERVAL=30  # Check every 30 seconds
LOG_FILE="/tmp/media-wake-guard.log"
INHIBIT_FILE="/tmp/media-wake-guard.inhibit"

# Function to log with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" >> "$LOG_FILE"
    echo "$1"
}


# Check dependencies
missing_deps=""
for cmd in pgrep pactl ps awk bc systemd-inhibit; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        missing_deps+="$cmd "
    fi
done

if [[ -n "$missing_deps" ]]; then
    echo "Error: Missing required dependencies: $missing_deps"
    echo "Please install the required packages and try again."
    exit 1
fi

# Main loop
log "Media Wake Guard started (PID: $$)"
log "Monitoring Firefox, Chrome, VLC, and Spotify for media playback"

