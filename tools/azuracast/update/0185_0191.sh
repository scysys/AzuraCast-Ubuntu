#!/usr/bin/env bash

##############################################################################
# This script will update AzuraCast from version 0.18.5 Stable to 0.19.1 Stable.
# Please note that this update process is designed for users who have previously used this installer for version 0.18.5 Stable.
# If you are upgrading from older versions, you should upgrade them one by one. For example, upgrade from 0.17.6 to 0.18.5 and then to 0.19.1.
##############################################################################

### Config
oldVersion="0.18.5"
newVersion="0.19.1"

### Prepare
# Ask the user if they are sure and have a backup
echo -e "\n\n---\n\n"
read -rp "Do you have a backup of your installation? (yes or no): " yn_one
echo
read -rp "Do you really want to upgrade to AzuraCast Stable $newVersion? (yes or no): " yn_two

# Check answers
if [[ "$yn_one" == "yes" || "$yn_one" == "scy" ]] && [[ "$yn_two" == "yes" || "$yn_two" == "scy" ]]; then
    echo
    echo "Upgrade will start now. I am lazy, so no logs this time like you have in the installation process."
    echo
else
    echo "Error: Your answers were not correct."
    exit 1
fi

# apt_get_with_lock
source tools/apt_get_with_lock.sh || { echo "Error sourcing apt_get_with_lock.sh"; exit 1; }

### AzuraCast related
# Check if the user started the right upgrade script
azv=/var/azuracast/www/src/Version.php
if [ -f "$azv" ]; then
    FALLBACK_VERSION="$(grep -oE "FALLBACK_VERSION = '.*';" "$azv" | sed "s/FALLBACK_VERSION = '//g;s/';//g")"
    echo -e "AzuraCast Version $FALLBACK_VERSION will be upgraded to $newVersion\n"
    
    if [ "$FALLBACK_VERSION" != "$oldVersion" ]; then
        echo "Invalid AzuraCast version. Exiting the script."
        exit 1
    fi
fi

# Generate the current date in the format YYYYMMDD
CURRENT_DATE=$(date +%Y%m%d)

# Combine $FALLBACK_VERSION and $CURRENT_DATE to create the backup filename
BACKUP_FILENAME="${FALLBACK_VERSION}_${CURRENT_DATE}.zip"

# Backup AzuraCast DB
chmod +x /var/azuracast/www/bin/console
/var/azuracast/www/bin/console azuracast:backup "$installerHome/tools/azuracast/update/backup/$BACKUP_FILENAME"
echo -e "Backup of $FALLBACK_VERSION is located in $installerHome/tools/azuracast/update/backup/$BACKUP_FILENAME\n"

### Update System
# First, we have to check if anything is up to date
export DEBIAN_FRONTEND=noninteractive
apt_get_with_lock update
apt_get_with_lock upgrade -y

### Stop Services
# Stop Zabbix (Only internal, but it will not disturb users who used this installer.)
systemctl stop zabbix-agent || :

# Stop all supervisor processes
supervisorctl stop all || :

### Now it's time for AzuraCast
# ups :p
rm -rf /var/azuracast/www_tmp/*

# Let correct permission. Who knows what users did on their files.
chown -R azuracast.azuracast /var/azuracast

# Better do it as the AzuraCast User
if [ $yn_one = "yes" ]; then
    su azuracast <<'EOF'
cd /var/azuracast/www
git stash
git pull
git checkout 0.18.5-org
cd /var/azuracast/www/frontend
export NODE_ENV=production
npm ci
npm run build
EOF
else
    su azuracast <<'EOF'
cd /var/azuracast/www
git stash
git pull
git checkout 0.18.5-scy
cd /var/azuracast/www/frontend
export NODE_ENV=production
npm ci
npm run build
EOF
fi

# Back to InstallerHome
cd $installerHome

# Read new config files
supervisorctl reread
supervisorctl update
supervisorctl restart redis

# Migrate Database
chmod +x /var/azuracast/www/bin/console
/var/azuracast/www/bin/console azuracast:setup:migrate

# Update Version (Not needed actually this file. But leave it for now)
echo "$newVersion" >/var/azuracast/azuracast_version.txt

# Just for sure correct permissions again
chown -R azuracast.azuracast /var/azuracast
