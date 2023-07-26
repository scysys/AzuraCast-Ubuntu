#!/usr/bin/env bash

# Installer already runned / EXIT
if [ -e "$installerHome/azuracast_installer_runned" ]; then
  echo "Installer has already been run. Exiting..."
  exit 1
fi

# Maybe its the easiest way instead of checking apt lock
systemctl stop unattended-upgrades || :

# Update package lists and upgrade packages
apt_get_with_lock update
apt_get_with_lock upgrade -y

# Add multiverse, universe, and restricted repositories
add-apt-repository -y multiverse
add-apt-repository -y universe
add-apt-repository -y restricted

# Update package lists
apt_get_with_lock update

# Prevent Installer to run more than one time
touch $installerHome/azuracast_installer_runned

# Issue: https://github.com/scysys/AzuraCast-Ubuntu/issues/1#issuecomment-1440983104
# Fix RackNerds Image
if grep -q "^adm:" /etc/group; then
  echo "adm group already exists, nothing to do."
else
  echo "adm group not found. Adding adm group with members syslog and ubuntu."
  echo "adm:x:4:syslog,ubuntu" >>/etc/group
fi

# Install system packages and dependencies
apt_get_with_lock install -y build-essential pwgen whois zstd software-properties-common \
  apt-transport-https ca-certificates language-pack-en tini gosu curl wget \
  tar zip unzip git rsync tzdata gpg-agent openssh-client openssl

# Set the system locale to en_US.UTF-8
# TODO: Not sure why it's here. It's from AzuraCast's default repo. Maybe some checks need the English language, so it's better to leave it for now.
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
