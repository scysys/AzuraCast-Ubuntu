#!/usr/bin/env bash

# Update package lists and install any missing dependencies
apt-get update
apt-get install -yf

# Upgrade all packages and dependencies
apt-get upgrade -y

# Remove not needed packages
apt-get autoremove -y

# Create a file to track the installer version and AzuraCast Version
echo "$set_installer_version" > "/var/azuracast/installer_version.txt"
chown azuracast:azuracast "/var/azuracast/installer_version.txt"

echo "$set_azuracast_version" > "/var/azuracast/azuracast_version.txt"
chown azuracast:azuracast "/var/azuracast/azuracast_version.txt"

# AzuraCast ENV Variables
touch /var/azuracast/www/azuracast.env
chown azuracast:azuracast "/var/azuracast/www/azuracast.env"
