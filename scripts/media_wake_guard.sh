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

# Function to check if media is playing in browsers (Firefox/Chrome)
check_browser_media() {
    # Just check if browsers have any uncorked audio streams
    pactl list sink-inputs 2>/dev/null | grep -B20 -A20 "Corked: no" | grep -q "application.name.*\(Firefox\|Chrome\|Chromium\)"
}

# Function to check if VLC is playing
check_vlc_media() {
    # Try D-Bus first (most reliable)
    if pgrep -x vlc >/dev/null 2>&1 && command -v qdbus >/dev/null 2>&1; then
        local vlc_status=$(qdbus org.mpris.MediaPlayer2.vlc /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.PlaybackStatus 2>/dev/null)
        if [[ "$vlc_status" == "Playing" ]]; then
            return 0
        fi
    fi
    
    # Fallback: check audio streams
    pactl list sink-inputs 2>/dev/null | grep -B20 -A20 "Corked: no" | grep -q "application.name.*VLC"
}

# Function to check if Spotify is playing
check_spotify_media() {
    # Try D-Bus first (most reliable)
    if pgrep -x spotify >/dev/null 2>&1 && command -v dbus-send >/dev/null 2>&1; then
        local spotify_status=$(dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.freedesktop.DBus.Properties.Get string:org.mpris.MediaPlayer2.Player string:PlaybackStatus 2>/dev/null | grep -o '"Playing"' | tr -d '"')
        if [[ "$spotify_status" == "Playing" ]]; then
            return 0
        fi
    fi
    
    # Fallback: check audio streams  
    pactl list sink-inputs 2>/dev/null | grep -B20 -A20 "Corked: no" | grep -q "application.name.*Spotify"
}

# Function to check all media sources
check_media_playing() {
    local media_active=false
    local active_sources=""
    
    if check_browser_media; then
        media_active=true
        active_sources+="Browser "
    fi
    
    if check_vlc_media; then
        media_active=true
        active_sources+="VLC "
    fi
    
    if check_spotify_media; then
        media_active=true
        active_sources+="Spotify "
    fi
    
    if $media_active; then
        echo "$active_sources"
        return 0
    else
        return 1
    fi
}

# Function to inhibit sleep and screen blanking
inhibit_sleep() {
    if [[ ! -f "$INHIBIT_FILE" ]]; then
        # Inhibit systemd sleep/suspend
        systemd-inhibit --what=sleep:idle --who="media-wake-guard" --why="Media playback active" --mode=block sleep infinity &
        echo $! > "$INHIBIT_FILE"
        
        # Disable DPMS (screen blanking/power saving)
        if command -v xset >/dev/null 2>&1 && [[ -n "$DISPLAY" ]]; then
            xset s off
            xset -dpms
        fi
        
        # Disable Wayland idle timeout if using GNOME
        if [[ "$XDG_SESSION_TYPE" == "wayland" ]] && command -v gsettings >/dev/null 2>&1; then
            gsettings set org.gnome.desktop.session idle-delay 0 2>/dev/null || true
        fi
        
        log "Sleep inhibition activated"
    fi
}

# Function to remove sleep inhibition
remove_inhibition() {
    if [[ -f "$INHIBIT_FILE" ]]; then
        local pid=$(cat "$INHIBIT_FILE")
        if kill "$pid" 2>/dev/null; then
            log "Stopped systemd-inhibit process (PID: $pid)"
        fi
        rm -f "$INHIBIT_FILE"
        
        # Re-enable DPMS
        if command -v xset >/dev/null 2>&1 && [[ -n "$DISPLAY" ]]; then
            xset s on
            xset +dpms
        fi
        
        # Re-enable Wayland idle timeout if using GNOME
        if [[ "$XDG_SESSION_TYPE" == "wayland" ]] && command -v gsettings >/dev/null 2>&1; then
            gsettings set org.gnome.desktop.session idle-delay 300 2>/dev/null || true
        fi
        
        log "Sleep inhibition removed"
    fi
}

# Function to cleanup on exit
cleanup() {
    log "Media Wake Guard stopping..."
    remove_inhibition
    exit 0
}

# Set up signal handlers
trap cleanup SIGINT SIGTERM EXIT

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
log "Media Wake Guard started (PID: $)"
log "Monitoring Firefox, Chrome, VLC, and Spotify for media playback"

while true; do
    # Add debug logging every few cycles to show script is alive
    if (( $(date +%s) % 300 == 0 )); then  # Every 5 minutes
        log "Script alive check - monitoring continues..."
    fi
    
    # Wrap media check in error handling
    if active_sources=$(check_media_playing 2>&1); then
        log "Media active in: $active_sources"
        inhibit_sleep
    else
        # Check if there was an error in media detection
        exit_code=$?
        if [[ $exit_code -ne 0 ]] && [[ -n "$active_sources" ]]; then
            log "Warning: Media check error: $active_sources"
        fi
        
        if [[ -f "$INHIBIT_FILE" ]]; then
            log "No media detected, removing inhibition"
        fi
        remove_inhibition
    fi
    
    # Add error handling for sleep command
    if ! sleep "$CHECK_INTERVAL"; then
        log "Error: Sleep command interrupted, continuing..."
    fi
done
