#!/usr/bin/env bash

##############################################################################
# This script will update AzuraCast from version 0.18.5 Stable to 0.19.1 Stable.
# Please note that this update process is designed for users who have previously used this installer for version 0.18.5 Stable.
# If you are upgrading from older versions, you should upgrade them one by one. For example, upgrade from 0.17.6 to 0.18.5 and then to 0.19.1.
##############################################################################

# Define the old and new versions
oldVersion="0.18.5"
newVersion="0.19.1"

# Prompt the user to confirm the update
echo -e "\n\n---\n\n"
read -rp "Do you have a backup of your installation? (yes or no): " yn_one
echo
read -rp "Do you really want to upgrade to AzuraCast Stable $newVersion? (yes or no): " yn_two

# Ensure user has given correct confirmation
if [[ "$yn_one" != "yes" && "$yn_one" != "scy" ]] || [[ "$yn_two" != "yes" && "$yn_two" != "scy" ]]; then
    echo "Error: Your answers were not correct."
    exit 1
fi

# Include external script
source tools/apt_get_with_lock.sh || { echo "Error sourcing apt_get_with_lock.sh"; exit 1; }

# Check for AzuraCast version compatibility
azv=/var/azuracast/www/src/Version.php
if [ -f "$azv" ]; then
    FALLBACK_VERSION="$(grep -oE "FALLBACK_VERSION = '.*';" "$azv" | sed "s/FALLBACK_VERSION = '//g;s/';//g")"
    echo -e "AzuraCast Version $FALLBACK_VERSION will be upgraded to $newVersion\n"
    
    if [ "$FALLBACK_VERSION" != "$oldVersion" ]; then
        echo "Invalid AzuraCast version. Exiting the script."
        exit 1
    fi
fi

# Backup the current AzuraCast version
CURRENT_DATE=$(date +%Y%m%d)  # Fetching current date
BACKUP_FILENAME="${FALLBACK_VERSION}_${CURRENT_DATE}.zip"
chmod +x /var/azuracast/www/bin/console
/var/azuracast/www/bin/console azuracast:backup "$installerHome/tools/azuracast/update/backup/$BACKUP_FILENAME"
echo -e "Backup of $FALLBACK_VERSION is located in $installerHome/tools/azuracast/update/backup/$BACKUP_FILENAME\n"

# Update system packages
export DEBIAN_FRONTEND=noninteractive
apt_get_with_lock update
apt_get_with_lock upgrade -y

# Stop services before updating
systemctl stop zabbix-agent || :
supervisorctl stop all || :

# Clean and prepare AzuraCast for the update
rm -rf /var/azuracast/www_tmp/*
chown -R azuracast.azuracast /var/azuracast

# Update AzuraCast
CHECKOUT_VERSION="0.18.5-$( [[ $yn_one == "yes" ]] && echo "org" || echo "scy" )"
su azuracast <<EOF
cd /var/azuracast/www
git stash
git pull
git checkout $CHECKOUT_VERSION
cd /var/azuracast/www/frontend
export NODE_ENV=production
npm ci
npm run build
EOF

# Refresh supervisor configs and restart necessary services
cd $installerHome
supervisorctl reread
supervisorctl update
supervisorctl restart redis

# Migrate database
chmod +x /var/azuracast/www/bin/console
/var/azuracast/www/bin/console azuracast:setup:migrate

# Update AzuraCast version file
echo "$newVersion" >/var/azuracast/azuracast_version.txt

# Ensure correct permissions post update
chown -R azuracast.azuracast /var/azuracast
