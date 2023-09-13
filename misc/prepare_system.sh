#!/usr/bin/env bash

# Exit if the installer has already been run
if [ -e "$installerHome/azuracast_installer_runned" ]; then
  echo "Installer has already been run. Exiting..."
  exit 1
fi

# Stop unattended-upgrades (suppress any errors)
systemctl stop unattended-upgrades || true

# Update and upgrade packages
apt_get_with_lock update
apt_get_with_lock upgrade -y

# Add multiverse, universe, and restricted repositories
add-apt-repository -y multiverse universe restricted

# Update package lists again
apt_get_with_lock update

# Mark installer as run
touch $installerHome/azuracast_installer_runned

# Issue: https://github.com/scysys/AzuraCast-Ubuntu/issues/1#issuecomment-1440983104
# Check for the existence of the adm group and create if it doesn't exist
if ! grep -q "^adm:" /etc/group; then
  echo "adm group not found. Adding adm group with members syslog and ubuntu."
  echo "adm:x:4:syslog,ubuntu" >>/etc/group
else
  echo "adm group already exists, nothing to do."
fi

# Install system packages and dependencies
apt_get_with_lock install -y build-essential pwgen whois zstd software-properties-common \
  apt-transport-https ca-certificates language-pack-en tini gosu curl wget \
  tar zip unzip git rsync tzdata gpg-agent openssh-client openssl

# Set the system locale to en_US.UTF-8
locale-gen en_US.UTF-8
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8
