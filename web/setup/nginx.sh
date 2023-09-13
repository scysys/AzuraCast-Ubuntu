#!/usr/bin/env bash

# Set variables for the nginx configuration directory and files
NGINX_DIR=/etc/nginx
PROXY_PARAMS_FILE=proxy_params
NGINX_CONF_FILE=nginx.conf
AZURACAST_CONF_FILE=azuracast.conf
AZURACAST_CONF_DIR=$NGINX_DIR/$AZURACAST_CONF_FILE.d

# Update the package lists and install the necessary dependencies
apt_get_with_lock update
apt_get_with_lock install -y curl nginx nginx-common openssl

# Backup the original files and copy the default nginx configuration files and enable the AzuraCast nginx configuration
mv -f $NGINX_DIR/$NGINX_CONF_FILE $NGINX_DIR/$NGINX_CONF_FILE.bak
cp web/nginx/$NGINX_CONF_FILE $NGINX_DIR/$NGINX_CONF_FILE

mv -f $NGINX_DIR/$PROXY_PARAMS_FILE $NGINX_DIR/$PROXY_PARAMS_FILE.bak
cp web/nginx/$PROXY_PARAMS_FILE.conf $NGINX_DIR/$PROXY_PARAMS_FILE

# Remove the default site configuration files and enable the AzuraCast site
rm -f $NGINX_DIR/sites-available/default
rm -f $NGINX_DIR/sites-enabled/default
cp web/nginx/$AZURACAST_CONF_FILE $NGINX_DIR/sites-available/
ln -s -f $NGINX_DIR/sites-available/$AZURACAST_CONF_FILE $NGINX_DIR/sites-enabled/

# Create the azuracast.conf.d directory and generate a self-signed SSL certificate
mkdir -p $AZURACAST_CONF_DIR
source web/nginx/self_signed_ssl.sh || { echo "Error sourcing self_signed_ssl.sh"; exit 1; }

# Create nginx temp dirs
mkdir -p /tmp/app_nginx_client /tmp/app_fastcgi_temp
touch /tmp/app_nginx_client/.tmpreaper
touch /tmp/app_fastcgi_temp/.tmpreaper
chmod -R 777 /tmp/app_*

# Disable and stop nginx service due to AzuraCast's Supervisor integration
systemctl disable nginx
systemctl stop nginx 
