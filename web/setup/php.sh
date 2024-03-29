#!/usr/bin/env bash

# Set variables for PHP version and directories
PHP_VERSION=${set_php_version}
PHP_DIR=/etc/php/${PHP_VERSION}
PHP_POOL_DIR=$PHP_DIR/fpm/pool.d
PHP_MODS_DIR=$PHP_DIR/mods-available
PHP_CONF_FILE=php.ini
PHP_POOL_FILE=www.conf
PHP_RUN_DIR=/run/php

# Add Ondrej's PHP repository and update package list
add-apt-repository -y ppa:ondrej/php

# Update package lists
apt_get_with_lock update

# Install PHP packages and required dependencies
apt_get_with_lock install -y curl php${PHP_VERSION}-fpm php${PHP_VERSION}-cli php${PHP_VERSION}-gd \
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
cp web/php/$PHP_CONF_FILE $PHP_POOL_DIR/
cp web/php/$PHP_POOL_FILE $PHP_POOL_DIR/

# Disable and stop PHP FPM because of Supervisor
systemctl disable php${PHP_VERSION}-fpm
systemctl stop php${PHP_VERSION}-fpm

# Set the default system php version to the one we want
update-alternatives --set php /usr/bin/php${PHP_VERSION}
