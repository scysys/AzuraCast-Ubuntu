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
touch /var/azuracast/www/azuracast.env
chown azuracast:azuracast "/var/azuracast/www/azuracast.env"

# Update Icecast to latest Version
source tools/icecastkh/update_latest.sh || { echo "Error sourcing tools/icecastkh/update_latest.sh"; exit 1; }
