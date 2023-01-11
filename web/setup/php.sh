#!/usr/bin/env bash

add-apt-repository -y ppa:ondrej/php

apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends php${set_php_version}-fpm php${set_php_version}-cli php${set_php_version}-gd \
  php${set_php_version}-curl php${set_php_version}-xml php${set_php_version}-zip php${set_php_version}-bcmath \
  php${set_php_version}-gmp php${set_php_version}-mysqlnd php${set_php_version}-mbstring php${set_php_version}-intl \
  php${set_php_version}-redis php${set_php_version}-maxminddb php${set_php_version}-xdebug \
  mariadb-client

# Copy PHP configuration
echo "PHP_VERSION=$set_php_version" >>/etc/php/.version

mkdir -p /run/php
touch /run/php/php${set_php_version}-fpm.pid

cp web/php/php.ini /etc/php/${set_php_version}/fpm/pool.d/azuracast_php.ini
cp web/php/www.conf /etc/php/${set_php_version}/fpm/pool.d/www.conf

# Because of AzuraCasts Supervisor Integration
systemctl disable php8.1-fpm
systemctl stop php8.1-fpm

# Install PHP SPX profiler
apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends php${set_php_version}-dev zlib1g-dev build-essential

mkdir -p bd_build/php-spx
cd bd_build/php-spx

git clone https://github.com/NoiseByNorthwest/php-spx.git .
phpize
./configure
make
make install

echo "extension=spx.so" >/etc/php/${set_php_version}/mods-available/30-spx.ini
ln -s /etc/php/${set_php_version}/mods-available/30-spx.ini /etc/php/${set_php_version}/cli/conf.d/30-spx.ini
ln -s /etc/php/${set_php_version}/mods-available/30-spx.ini /etc/php/${set_php_version}/fpm/conf.d/30-spx.ini

cd $installerHome
