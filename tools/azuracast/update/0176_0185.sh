#!/usr/bin/env bash

##############################################################################
# This will update AzuraCast 0.17.6 Stable to 0.18.5 Stable
# This will only work if you previously used this installer for version 0.17.6 Stable.
##############################################################################

### Config
newVersion=0.18.5

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

### AzuraCast related
# Check if the user started the right upgrade script
azv=/var/azuracast/www/src/Version.php
if [ -f "$azv" ]; then
    FALLBACK_VERSION="$(grep -oE "FALLBACK_VERSION = '.*';" "$azv" | sed "s/FALLBACK_VERSION = '//g;s/';//g")"
    echo -e "AzuraCast Version $FALLBACK_VERSION will be upgraded to $newVersion\n"

    if [ "$FALLBACK_VERSION" != "0.17.6" ]; then
        echo "Invalid AzuraCast version. Exiting the script."
        exit 1
    fi
fi

# Backup AzuraCast DB
chmod +x /var/azuracast/www/bin/console
/var/azuracast/www/bin/console azuracast:backup $installerHome/tools/azuracast/update/backup/$FALLBACK_VERSION.zip
echo -e "Backup of $FALLBACK_VERSION is located in $installerHome/tools/azuracast/update/backup/$FALLBACK_VERSION.zip\n"

### Update System
# First, we have to check if anything is up to date
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get -y upgrade

### Stop Services
# Stop Zabbix (Only internal, but it will not disturb users who used this installer.)
systemctl stop zabbix-agent || :

# Stop all supervisor processes
supervisorctl stop all || :

### Update PHP to 8.2 (0.17.6 was using 8.1)
PHP_VERSION=8.2
PHP_DIR=/etc/php/${PHP_VERSION}
PHP_POOL_DIR=$PHP_DIR/fpm/pool.d
PHP_MODS_DIR=$PHP_DIR/mods-available
PHP_RUN_DIR=/run/php

# Install PHP packages and required dependencies
apt-get install -y curl php${PHP_VERSION}-fpm php${PHP_VERSION}-cli php${PHP_VERSION}-gd \
    php${PHP_VERSION}-curl php${PHP_VERSION}-xml php${PHP_VERSION}-zip \
    php${PHP_VERSION}-bcmath php${PHP_VERSION}-gmp php${PHP_VERSION}-mysqlnd \
    php${PHP_VERSION}-mbstring php${PHP_VERSION}-intl php${PHP_VERSION}-redis \
    php${PHP_VERSION}-maxminddb php${PHP_VERSION}-xdebug \
    php${PHP_VERSION}-dev zlib1g-dev build-essential

# Set PHP version
echo "PHP_VERSION=$PHP_VERSION" >>/etc/php/.version

# Create required directories and files
mkdir -p $PHP_RUN_DIR
touch $PHP_RUN_DIR/php${PHP_VERSION}-fpm.pid

# Copy PHP configuration files
curl -s -o $PHP_POOL_DIR/php.ini https://raw.githubusercontent.com/scysys/AzuraCast-Ubuntu/$newVersion/web/php/php.ini
curl -s -o $PHP_POOL_DIR/www.conf https://raw.githubusercontent.com/scysys/AzuraCast-Ubuntu/$newVersion/web/php/www.conf

# Copy Supervisors php-fpm.conf
curl -s -o /etc/supervisor/conf.d/php-fpm.conf https://raw.githubusercontent.com/scysys/AzuraCast-Ubuntu/$newVersion/supervisor/conf.d/php-fpm.conf

# Disable and stop PHP FPM because of Supervisor
systemctl disable php8.1-fpm
systemctl stop php8.1-fpm
systemctl disable php${PHP_VERSION}-fpm
systemctl stop php${PHP_VERSION}-fpm

# Set the default system PHP version to the one we want
update-alternatives --set php /usr/bin/php${PHP_VERSION}

### Redis is new in this version
# Install Redis
apt-get install -y --no-install-recommends redis-server

# Get redis.conf
curl -s -o /etc/redis/redis.conf https://raw.githubusercontent.com/scysys/AzuraCast-Ubuntu/$newVersion/redis/redis.conf
chown redis.redis /etc/redis/redis.conf

# Get supervisor redis.conf
curl -s -o /etc/supervisor/conf.d/redis.conf https://raw.githubusercontent.com/scysys/AzuraCast-Ubuntu/$newVersion/supervisor/conf.d/redis.conf

# Stop Redis
systemctl disable redis-server || :
systemctl stop redis-server || :

### Now it's time for AzuraCast
# ups :p
rm -rf /var/azuracast/www_tmp/*

# Better do it as the AzuraCast User
if [ $yn_one = "yes" ]; then
    su azuracast <<'EOF'
cd /var/azuracast/www
git stash
git pull
git checkout 0.18.5-org
EOF
else
    su azuracast <<'EOF'
cd /var/azuracast/www
git stash
git pull
git checkout 0.18.5-scy
EOF
fi

# NPM Build
cd /var/azuracast/www/frontend
export NODE_ENV=production
npm ci
npm run build

# Read new config files
supervisorctl reread
supervisorctl update
supervisorctl restart redis

# Migrate Database
chmod +x /var/azuracast/www/bin/console
/var/azuracast/www/bin/console azuracast:migrate

# Remove
rm -f /var/azuracast/installer_version.txt

# Update Version (Not needed actually this file. But leave it for now)
echo "$newVersion" >/var/azuracast/azuracast_version.txt
