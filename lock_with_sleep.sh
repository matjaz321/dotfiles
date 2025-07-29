#!/bin/bash
# Start the sleep timer in background
(
    sleep 60
    # Only turn off display if i3lock is still running
    if pgrep -x i3lock > /dev/null; then
        xset dpms force off
    fi
) &

# Store the background job PID
SLEEP_PID=$!

# start the lock
i3lock --inside-color=00000000 --ring-color=808080ff --clock --image=/home/matjaz/dotfiles/wallpapers/a_group_of_pink_flowers_blurred.jpg --keyhl-color=ff808080 --bshl-color=ff6666ff --time-color=ffffffff --date-color=ffffffff --insidever-color=ff999980 --ringver-color=ff9999ff --verif-color=ffffffff --noinput-text="No Input" --modif-color=ff999980 --screen=1

xset dpms force on
