#!/usr/bin/env bash

##############################################################################
# AzuraCast is storing the Logfiles in www_tmp with much other files.
# I personally like it, when everything is somewhat in order.
##############################################################################

# supervisord
rm -f /var/azuracast/www_tmp/supervisord.log
ln -s /var/azuracast/logs/supervisord.log /var/azuracast/www_tmp/supervisord.log

# nginx
rm -f /var/azuracast/www_tmp/access.log
ln -s /var/azuracast/logs/service_nginx_access.log /var/azuracast/www_tmp/access.log

rm -f /var/azuracast/www_tmp/error.log
ln -s /var/azuracast/logs/service_nginx_error.log /var/azuracast/www_tmp/error.log

# php
rm -f /var/azuracast/www_tmp/php_errors.log
ln -s /var/azuracast/logs/service_php_fpm.log /var/azuracast/www_tmp/php_errors.log
