#!/usr/bin/env bash

# Set variables for the crontab file and the specified jobs
CRONTAB_FILE=/etc/cron.d/azuracast_user
SYNC_JOB="* * * * * azuracast php /var/azuracast/www/bin/console azuracast:sync:run"
CLEAR_JOB="0 0 * * * azuracast php /var/azuracast/www/bin/console azuracast:station-queues:clear"
TEMPREAPER_JOB="0 */6 * * * azuracast tmpreaper 12h /var/azuracast/stations/*/temp"

# Populate the crontab with the specified jobs
echo -e "$SYNC_JOB\n$CLEAR_JOB\n$TEMPREAPER_JOB" >$CRONTAB_FILE

# Set the appropriate permissions for the crontab file
chown root.root $CRONTAB_FILE

# Disable and stop service due to AzuraCast's Supervisor integration
systemctl disable cron
