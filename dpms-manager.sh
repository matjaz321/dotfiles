#!/bin/bash

# Get applications currently playing audio
playing_apps=$(pactl list sink-inputs | grep -A 30 "Corked: no" | grep -i "application.name = " | cut -d'"' -f2)

if echo "$playing_apps" | grep -qi "firefox\|chrome\|spotify\|vlc"; then
    xset -dpms
    echo "Media app playing: $playing_apps - DPMS disabled"
else
    xset dpms 300 300 600
    echo "No media apps playing - DPMS enabled"
fi
