#!/bin/bash

# Config: layouts and their display names
LAYOUTS=("us" "si")
LAYOUT_NAMES=("EN" "SI")

STATE_FILE="/tmp/polybar_keyboard_layout_state"

# Initialize state file if missing
if [ ! -f "$STATE_FILE" ]; then
  echo 0 > "$STATE_FILE"
fi

# Read current index
INDEX=$(cat "$STATE_FILE")

# If argument is "toggle", switch to next layout
if [ "$1" == "toggle" ]; then
  NEXT=$(( (INDEX + 1) % ${#LAYOUTS[@]} ))
  setxkbmap "${LAYOUTS[$NEXT]}"
  echo "$NEXT" > "$STATE_FILE"
  INDEX=$NEXT
fi

# Print current layout name for Polybar display
echo "${LAYOUT_NAMES[$INDEX]}"

