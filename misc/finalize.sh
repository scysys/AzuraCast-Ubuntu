#!/usr/bin/env bash

# Update package lists and install any missing dependencies
apt_get_with_lock update
apt_get_with_lock install -yf

# Upgrade all packages and dependencies
apt_get_with_lock upgrade -y

# Remove not needed packages
apt_get_with_lock autoremove -y

echo "$set_azuracast_version" > "/var/azuracast/azuracast_version.txt"
chown azuracast:azuracast "/var/azuracast/azuracast_version.txt"

# AzuraCast ENV Variables
ENV_FILE=/var/azuracast/www/azuracast.env
touch "$ENV_FILE"
chown azuracast:azuracast "$ENV_FILE"
echo "ENABLE_WEB_UPDATER=false" >> "$ENV_FILE"

if [ "$azuracast_git_version" = "scy" ]; then
    echo "NOW_PLAYING_MAX_CONCURRENT_PROCESSES=1" >> "$ENV_FILE"
fi

# Update Icecast to latest Version
source tools/icecastkh/update_latest.sh || { echo "Error sourcing tools/icecastkh/update_latest.sh"; exit 1; }
