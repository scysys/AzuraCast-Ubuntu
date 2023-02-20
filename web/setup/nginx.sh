#!/usr/bin/env bash

# Set variables for the nginx configuration directory and files
NGINX_DIR=/etc/nginx
PROXY_PARAMS_FILE=proxy_params
NGINX_CONF_FILE=nginx.conf
AZURACAST_CONF_FILE=azuracast.conf
AZURACAST_CONF_DIR=$NGINX_DIR/$AZURACAST_CONF_FILE.d

# Update the package lists and install the necessary dependencies
apt-get update
apt-get install -o DPkg::Lock::Timeout=-1 -y curl nginx openssl

# Backup the original files and copy the AzuraCast configuration files
for file in $PROXY_PARAMS_FILE $NGINX_CONF_FILE; do
    mv -f $NGINX_DIR/$file $NGINX_DIR/$file.bak
    cp web/nginx/$file.conf $NGINX_DIR/$file
done

# Remove the default site configuration files and enable the AzuraCast site
rm -f $NGINX_DIR/sites-available/default
rm -f $NGINX_DIR/sites-enabled/default
cp web/nginx/$AZURACAST_CONF_FILE $NGINX_DIR/sites-available/
ln -s -f $NGINX_DIR/sites-available/$AZURACAST_CONF_FILE $NGINX_DIR/sites-enabled/

# Create the azuracast.conf.d directory and generate a self-signed SSL certificate
mkdir -p $AZURACAST_CONF_DIR
source web/nginx/self_signed_ssl.sh || { echo "Error sourcing self_signed_ssl.sh"; exit 1; }

# Disable and stop nginx service due to AzuraCast's Supervisor integration
systemctl disable nginx
systemctl stop nginx
