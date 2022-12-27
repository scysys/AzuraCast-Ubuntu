#!/usr/bin/env bash

# Create Crontab File
touch /var/spool/cron/crontabs/azuracast

# Popluate crontab
echo "
* * * * * php /var/azuracast/www/bin/console azuracast:sync:run
0 */6 * * * tmpreaper 12h /var/azuracast/stations/*/temp
" >>/var/spool/cron/crontabs/azuracast

# Make sure Permissions are the right one
chmod 0600 /var/spool/cron/crontabs/azuracast
chown azuracast.crontab /var/spool/cron/crontabs/azuracast

# Because of Azuracasts Supervisor Integration
systemctl disable cron
systemctl stop cron
