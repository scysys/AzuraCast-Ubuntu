#!/usr/bin/env bash

##############################################################################
# setup_azuracast_user
##############################################################################

# Install required packages
apt_get_with_lock install -y --no-install-recommends sudo

# Add user
adduser --home /var/azuracast --disabled-password --gecos "" azuracast
usermod -aG www-data azuracast

# Define base directory
BASE_DIR="/var/azuracast"

# Create directories
mkdir -p $BASE_DIR/{www,stations,servers/{shoutcast2,stereo_tool},backups,www_tmp,uploads,geoip,dbip,centrifugo,sftpgo/{persist,backups},acme,logs}

# Adjust permissions
chmod -R 777 $BASE_DIR/www_tmp

# Set ownership
chown -R azuracast:azuracast $BASE_DIR
