#!/bin/bash
# Start the sleep timer in background
#(
#    sleep 60
#    # Only turn off display if i3lock is still running
#    if pgrep -x i3lock > /dev/null; then
#        xset dpms force off
#    fi
#) &

# Save current DPMS settings
dpms_settings=$(xset q | grep "DPMS is" | awk '{print $3}')

xset dpms 300 300 300

# Save current DPMS settings

# Store the background job PID
#SLEEP_PID=$!

# start the lock
i3lock --inside-color=00000000 --ring-color=808080ff --clock --image=/home/matjaz/dotfiles/wallpapers/a_group_of_pink_flowers_blurred.jpg --keyhl-color=ff808080 --bshl-color=ff6666ff --time-color=ffffffff --date-color=ffffffff --insidever-color=ff999980 --ringver-color=ff9999ff --verif-color=ffffffff --noinput-text="No Input" --modif-color=ff999980 --screen=1

# Restore original DPMS settings after unlock
if [ "$dpms_settings" = "Enabled" ]; then
    xset dpms 300 600 600  # or whatever your original settings were
else
    xset -dpms
fi
