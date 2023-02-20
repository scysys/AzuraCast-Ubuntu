#!/usr/bin/env bash

# Install Supervisor
apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends supervisor

CONFIG_DIR="/etc/supervisor/conf.d"
SUPERVISOR_CONFIG="/etc/supervisor/supervisord.conf"
SERVICE_CONFIG_FILES=("beanstalkd.conf" "centrifugo.conf" "cron.conf" "nginx.conf" "php-fpm.conf" "php-nowplaying.conf" "php-worker.conf" "sftpgo.conf" "mariadb.conf")

mkdir -p "$CONFIG_DIR"

# supervisord
cp supervisor/config/supervisord.conf "$SUPERVISOR_CONFIG"

# supervisor services
for file in "${SERVICE_CONFIG_FILES[@]}"; do
    cp "supervisor/conf.d/$file" "$CONFIG_DIR/$file"
done

# Enable Service
systemctl enable supervisor

# Reload systemd configuration
systemctl daemon-reload

# Read new config files
supervisorctl reread
supervisorctl update

# Correct MySQL Permissions
chown -R mysql.mysql /var/lib/mysql

# Restart Supervisor services
service supervisor restart || :
supervisorctl restart all || :
