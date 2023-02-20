#!/usr/bin/env bash

# Update package lists and install any missing dependencies
apt-get update
apt-get install -o DPkg::Lock::Timeout=-1 -yf

# Upgrade all packages and dependencies
apt-get upgrade -o DPkg::Lock::Timeout=-1 -y

# Create a file to track the installer version
echo "do not delete" > "/var/azuracast/www/installer_version_$set_installer_version.txt"
chown azuracast:azuracast "/var/azuracast/www/installer_version_$set_installer_version.txt"
