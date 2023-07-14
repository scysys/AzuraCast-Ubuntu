#!/usr/bin/env bash

##############################################################################
# This will update AzuraCast 0.17.6 Stable to 0.18.5 Stabel
# This will only work if you previusly used this installer here for 0.17.6 Stable
##############################################################################

### Prepare
# Ask user if he is sure and have backup
read -rp "Do you have a Backup of your installtion? (yes or no): " yn_one
echo
read -rp "Do you really want to upgrade to AzuraCast Stable 0.18.5? Machine will be also rebooted! (yes or no): " yn_two

# check answers
if $yn_one == "yes" or "scy" && $yn_two == "yes" or "scy"; then
    echo
    echo "Upgrade will start now. I am lazy so no logs this time like you have in install process."
    echo
else
    echo "Error: Exited your answers where no correct."
    exit 1
fi

### Update System
# First we have to check is anything up to date
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
curl -s -o $PHP_POOL_DIR/php.ini https://raw.githubusercontent.com/scysys/AzuraCast-Ubuntu/0.18.5/web/php/php.ini
curl -s -o $PHP_POOL_DIR/www.conf https://raw.githubusercontent.com/scysys/AzuraCast-Ubuntu/0.18.5/web/php/www.conf

# Disable and stop PHP FPM because of Supervisor
systemctl disable php8.1-fpm
systemctl stop php8.1-fpm
systemctl disable php${PHP_VERSION}-fpm
systemctl stop php${PHP_VERSION}-fpm

# Set the default system php version to the one we want
update-alternatives --set php /usr/bin/php${PHP_VERSION}

### Redis is new at 0.18.5
# Install redis
apt-get install -y --no-install-recommends redis-server

# Get redis.conf
curl -s -o /etc/redis/redis.conf https://raw.githubusercontent.com/scysys/AzuraCast-Ubuntu/0.18.5/redis/redis.conf
chown redis.redis /etc/redis/redis.conf

# Get supervisor redis.conf
curl -s -o /etc/supervisor/conf.d/redis.conf https://raw.githubusercontent.com/scysys/AzuraCast-Ubuntu/0.18.5/supervisor/conf.d/redis.conf

# Stop it
systemctl disable redis-server || :
systemctl stop redis-server  || :

### Now its time for AzuraCast
# ups :p
rm -rf /var/azuracast/www_tmp/*

# Better do as AzuraCast User
if [ $yn_one = "yes" ]; then
    su azuracast <<'EOF'
cd /var/azuracast/www
git stash
git pull
git checkout 0.18.5-org
composer --working-dir=/var/azuracast/www install --no-dev --no-ansi --no-interaction
EOF
else
    su azuracast <<'EOF'
cd /var/azuracast/www
git stash
git pull
git checkout 0.18.5-scy
composer --working-dir=/var/azuracast/www install --no-dev --no-ansi --no-interaction
EOF
fi

# NPM Build
cd /var/azuracast/www/frontend
export NODE_ENV=production
npm ci
npm run build

# Remove
rm -f /var/azuracast/installer_version.txt

# forget something?
