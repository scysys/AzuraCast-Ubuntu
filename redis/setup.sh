#!/usr/bin/env bash

# Update package lists & Install Redis server
apt_get_with_lock update && apt_get_with_lock install -y --no-install-recommends redis-server

# Disable and stop the Redis service
systemctl disable redis-server || true
systemctl stop redis-server || true

# Copy redis.conf
cp redis/redis.conf /etc/redis/redis.conf
chown redis:redis /etc/redis/redis.conf
