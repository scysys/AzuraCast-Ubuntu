#!/usr/bin/env bash

# Install Supervisor
apt_get_with_lock install -y --no-install-recommends supervisor

CONFIG_DIR="/etc/supervisor/conf.d"
mkdir -p "$CONFIG_DIR"

SUPERVISOR_MAIN_CONFIG="/etc/supervisor/supervisord.conf"
SERVICE_CONFIGS=("beanstalkd.conf" "centrifugo.conf" "cron.conf" "nginx.conf" "php-fpm.conf" "php-nowplaying.conf" "php-worker.conf" "sftpgo.conf" "mariadb.conf" "redis.conf")

# Copy main supervisord configuration
cp supervisor/config/supervisord.conf "$SUPERVISOR_MAIN_CONFIG"

# Copy service configurations
for config in "${SERVICE_CONFIGS[@]}"; do
    cp "supervisor/conf.d/$config" "$CONFIG_DIR/$config"
done

# Enable and configure Supervisor
systemctl enable supervisor
systemctl daemon-reload
supervisorctl reread && supervisorctl update

# Correct MySQL Permissions
chown -R mysql:mysql /var/lib/mysql

# Restart Supervisor services
systemctl restart supervisor || :
supervisorctl restart all || :
