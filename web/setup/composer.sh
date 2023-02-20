#!/usr/bin/env bash

# Set variables for the Composer installation location and the download URL
COMPOSER_INSTALL_PATH=/usr/bin
COMPOSER_DOWNLOAD_URL=https://getcomposer.org/installer

# Update package lists and install the necessary dependencies
apt-get update
apt-get install -o DPkg::Lock::Timeout=-1 -y curl php-cli php-mbstring git unzip

# Download the Composer installer and verify the signature
EXPECTED_SIGNATURE=$(curl -sS https://composer.github.io/installer.sig)
php -r "copy('$COMPOSER_DOWNLOAD_URL', 'composer-setup.php');"
ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")
if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]; then
    >&2 echo 'ERROR: Invalid installer signature'
    rm composer-setup.php
    exit 1
fi

# Install Composer and move it to the installation path
php composer-setup.php --install-dir=${COMPOSER_INSTALL_PATH} --filename=composer
rm composer-setup.php
