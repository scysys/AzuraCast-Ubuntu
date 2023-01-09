#!/usr/bin/env bash

##############################################################################
# finalize
##############################################################################

# Check if everything is right
apt-get install -o DPkg::Lock::Timeout=-1 -yf
apt-get update -o DPkg::Lock::Timeout=-1
apt-get upgrade -o DPkg::Lock::Timeout=-1 -y

# Create a file where i can get the installer version
touch /var/azuracast/www/installer_version_$set_installer_version.txt
echo "do not delete" > /var/azuracast/www/installer_version_$set_installer_version.txt
chown azuracast.azuracast /var/azuracast/www/installer_version_$set_installer_version.txt
