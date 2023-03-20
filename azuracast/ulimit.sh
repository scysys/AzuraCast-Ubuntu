#!/usr/bin/env bash

# Add 'nofile' limits for user 'azuracast' to /etc/security/limits.conf
sudo bash -c '
echo -e "\n# Limits for user azuracast"
echo "azuracast soft nofile 65536"
echo "azuracast hard nofile 65536"
' >> /etc/security/limits.conf
