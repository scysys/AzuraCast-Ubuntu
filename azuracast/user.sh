#!/usr/bin/env bash

##############################################################################
# setup_azuracast_user
##############################################################################

apt-get install -y --no-install-recommends sudo

adduser --home /var/azuracast --disabled-password --gecos "" azuracast
usermod -aG www-data azuracast

# AzuraCast working dir
mkdir -p /var/azuracast/www

# AzuraCast Stations
mkdir -p /var/azuracast/stations

# AzuraCast Stream Servers
mkdir -p /var/azuracast/servers
mkdir -p /var/azuracast/servers/shoutcast2
mkdir -p /var/azuracast/servers/stereo_tool

# AzuraCast Backups
mkdir -p /var/azuracast/backups

# AzuraCast TMP
mkdir -p /var/azuracast/www_tmp
chmod -R 777 /var/azuracast/www_tmp # ??? 777 in 2022 ???

# AzuraCast Uploads
mkdir -p /var/azuracast/uploads

# AzuraCast GeoIP
mkdir -p /var/azuracast/geoip

# AzuraCast GeoIP
mkdir -p /var/azuracast/dbip

# Centrifugo
mkdir -p /var/azuracast/centrifugo

# SFTGO
#mkdir -p /var/azuracast/sftpgo
mkdir -p /var/azuracast/sftpgo/persist
mkdir -p /var/azuracast/sftpgo/backups

# Certbot
mkdir -p /var/azuracast/acme

# Supervisor Logs
mkdir -p /var/azuracast/logs

# Correct Permissions
chown -R azuracast:azuracast /var/azuracast

