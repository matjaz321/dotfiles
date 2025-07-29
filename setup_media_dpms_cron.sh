#!/bin/bash

SCRIPT_PATH="/home/matjaz/dotfiles/scripts/media_dpms_check.sh"
CRON_JOB="*/3 * * * * $SCRIPT_PATH"


# Check if the cron job already exists
if crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH"; then
    echo "Cron job for media DPMS check already exists"
    echo "Current crontab:"
    crontab -l | grep "$SCRIPT_PATH"
else
    # Add the cron job
    (crontab -l 2>/dev/null; echo "$CRON_JOB") | crontab -
    echo "Added cron job: $CRON_JOB"
    echo "Media DPMS check will run every 3 minutes"
fi

echo "Setup complete!"
