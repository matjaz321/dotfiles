#!/usr/bin/env bash

# Get active window ID
wid=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')

# Check if we got a valid window ID
if [ -z "$wid" ] || [ "$wid" = "0x0" ] || [ "$wid" = "0x00000000" ]; then
    echo "Desktop"
    exit 0
fi

# Normalize to 0xXXXXXXXX format
wid=$(printf "0x%08x\n" $((wid)))

# Validate the window ID exists before trying to get properties
if ! xprop -id "$wid" >/dev/null 2>&1; then
    echo "Desktop"
    exit 0
fi

# Get PID of the window
pid=$(xprop -id "$wid" _NET_WM_PID 2>/dev/null | awk '{print $3}') 

# If no PID found, try to get window class/name instead
if [ -z "$pid" ] || [ "$pid" = "" ]; then
    # Try WM_CLASS first
    app=$(xprop -id "$wid" WM_CLASS 2>/dev/null | cut -d'"' -f4)
    
    # If WM_CLASS fails, try WM_NAME
    if [ -z "$app" ]; then
        app=$(xprop -id "$wid" WM_NAME 2>/dev/null | cut -d'"' -f2)
    fi
    
    # Still no luck? Show Desktop
    if [ -z "$app" ]; then
        echo "Desktop"
        exit 0
    fi
else
    # Get the application name from PID
    app=$(ps -p "$pid" -o comm= 2>/dev/null)
    
    # If ps fails, fall back to WM_CLASS
    if [ -z "$app" ]; then
        app=$(xprop -id "$wid" WM_CLASS 2>/dev/null | cut -d'"' -f4)
    fi
fi

# Final check
if [ -z "$app" ]; then
    echo "Desktop"
    exit 0
fi

# Clean up the name and capitalize first letter
app=$(echo "$app" | tr -d '\n' | tr -d '\r')
app_capitalized=$(echo "$app" | sed -E 's/(.)(.*)/\U\1\E\2/')

echo "$app_capitalized"
