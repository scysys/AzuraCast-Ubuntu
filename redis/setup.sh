#!/usr/bin/env bash

# Update package lists
apt_get_with_lock update

# Install Redis server
apt_get_with_lock install -y --no-install-recommends sftpgo redis-server

# Disable and stop the Redis service
systemctl disable redis-server || true
systemctl stop redis-server || true

# Copy redis.conf
cp redis/redis.conf /etc/redis/redis.conf
chown redis:redis /etc/redis/redis.conf
