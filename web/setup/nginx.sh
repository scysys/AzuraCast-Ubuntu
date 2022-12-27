#!/usr/bin/env bash

apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends nginx nginx-common openssl

# Install nginx and configuration
mv /etc/nginx/proxy_params /etc/nginx/proxy_params.bak
cp web/nginx/proxy_params.conf /etc/nginx/proxy_params

mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
cp web/nginx/nginx.conf /etc/nginx/nginx.conf

rm -f /etc/nginx/sites-available/default
rm -f /etc/nginx/sites-enabled/default

cp web/nginx/azuracast.conf /etc/nginx/sites-available/azuracast.conf
ln -s -f /etc/nginx/sites-available/azuracast.conf /etc/nginx/sites-enabled/

mkdir -p /etc/nginx/azuracast.conf.d/

# Self Signed SSL
source web/nginx/self_signed_ssl.sh

# Because of Azuracasts Supervisor Integration
systemctl disable nginx
systemctl stop nginx
