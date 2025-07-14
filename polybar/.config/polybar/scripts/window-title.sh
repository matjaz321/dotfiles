#!/bin/bash

get_focused_window() {
    # Get the actually focused window ID
    active_window_id=$(xprop -root _NET_ACTIVE_WINDOW 2>/dev/null | cut -d' ' -f5)
    
    if [ "$active_window_id" != "0x0" ] && [ -n "$active_window_id" ]; then
        # Get the title of the focused window
        title=$(xprop -id "$active_window_id" WM_NAME 2>/dev/null | cut -d'"' -f2)
        
        # Filter out polybar windows
        if [[ "$title" == *"polybar"* ]]; then
            echo "Desktop"
        else
            echo "${title:-Desktop}"
        fi
    else
        echo "Desktop"
    fi
}

# Run in tail mode for real-time updates
while true; do
    get_focused_window
    sleep 0.1
done
