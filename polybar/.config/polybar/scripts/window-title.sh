#!/usr/bin/env bash

# Get active window ID
wid=$(xprop -root _NET_ACTIVE_WINDOW | awk '{print $5}')
[ -z "$wid" ] && echo "N/A" && exit

# Normalize to 0xXXXXXXXX format
wid=$(printf "0x%08x\n" $((wid)))

# Get PID of the window
pid=$(xprop -id "$wid" _NET_WM_PID | awk '{print $3}')
[ -z "$pid" ] && echo "N/A" && exit

# Get the application name
app=$(ps -p "$pid" -o comm=)
[ -z "$app" ] && echo "N/A" && exit

# Capitalize first letter
app_capitalized=$(echo "$app" | sed -E 's/(.)(.*)/\U\1\E\2/')

echo "$app_capitalized"

