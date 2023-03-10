#!/usr/bin/env bash

# Update package lists and upgrade packages
apt-get update
apt-get upgrade -y

# Add multiverse, universe, and restricted repositories
add-apt-repository -y multiverse
add-apt-repository -y universe
add-apt-repository -y restricted

# Update package lists
apt-get update

# Issue: https://github.com/scysys/AzuraCast-Ubuntu/issues/1#issuecomment-1440983104
# Fix RackNerds Image
if grep -q "^adm:" /etc/group; then
  echo "adm group already exists, nothing to do."
else
  echo "adm group not found. Adding adm group with members syslog and ubuntu."
  echo "adm:x:4:syslog,ubuntu" >> /etc/group
fi

# Install system packages and dependencies
apt-get install -y build-essential pwgen whois zstd software-properties-common \
    apt-transport-https ca-certificates language-pack-en tini gosu curl wget \
    tar zip unzip git rsync tzdata gpg-agent openssh-client openssl

# Set the system locale to en_US.UTF-8
# TODO: Not sure why it's here. It's from AzuraCast's default repo. Maybe some checks need the English language, so it's better to leave it for now.
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
