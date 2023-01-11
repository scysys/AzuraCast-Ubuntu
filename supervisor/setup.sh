#!/usr/bin/env bash

##############################################################################
# azuracast_user
##############################################################################

apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends supervisor

mkdir -p /etc/supervisor/conf.d/

# supervisord
cp supervisor/config/supervisord.conf /etc/supervisor/

# supervisor services
cp supervisor/conf.d/beanstalkd.conf /etc/supervisor/conf.d/beanstalkd.conf
cp supervisor/conf.d/centrifugo.conf /etc/supervisor/conf.d/centrifugo.conf
cp supervisor/conf.d/cron.conf /etc/supervisor/conf.d/cron.conf
cp supervisor/conf.d/nginx.conf /etc/supervisor/conf.d/nginx.conf
cp supervisor/conf.d/php-fpm.conf /etc/supervisor/conf.d/php-fpm.conf
cp supervisor/conf.d/php-nowplaying.conf /etc/supervisor/conf.d/php-nowplaying.conf
cp supervisor/conf.d/php-worker.conf /etc/supervisor/conf.d/php-worker.conf
cp supervisor/conf.d/sftpgo.conf /etc/supervisor/conf.d/sftpgo.conf
cp supervisor/conf.d/mariadb.conf /etc/supervisor/conf.d/mariadb.conf

# Enable Service
systemctl enable supervisor

# Read new config files
supervisorctl reread
supervisorctl update

# Correct MySQL Permissions
chown -R mysql.mysql /var/lib/mysql

# Restart Supervisor services
supervisorctl restart all || :
