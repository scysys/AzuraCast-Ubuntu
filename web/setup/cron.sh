#!/usr/bin/env bash

# Set variables for the crontab file and the specified jobs
CRONTAB_FILE=/etc/cron.d/azuracast
SYNC_JOB="* * * * * azuracast php /var/azuracast/www/bin/console azuracast:sync:run"
CLEAR_JOB="0 0 * * * azuracast php /var/azuracast/www/bin/console azuracast:station-queues:clear"
TEMPREAPER_JOB="0 */6 * * * azuracast tmpreaper 12h /var/azuracast/stations/*/temp"

# Create the AzuraCast user's crontab file
touch $CRONTAB_FILE

# Populate the crontab with the specified jobs
echo -e "$SYNC_JOB\n$CLEAR_JOB\n$TEMPREAPER_JOB" >$CRONTAB_FILE

# Set the appropriate permissions for the crontab file
chmod 0600 $CRONTAB_FILE
chown azuracast.crontab $CRONTAB_FILE

# Disable and stop service due to AzuraCast's Supervisor integration
systemctl disable cron
