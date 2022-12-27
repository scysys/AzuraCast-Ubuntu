#!/usr/bin/env bash

##############################################################################
# prepare_system
##############################################################################

# Make sure System is Up-To-Date
apt-get update -o DPkg::Lock::Timeout=-1
apt-get upgrade -o DPkg::Lock::Timeout=-1 -y

### Reference: docker/common/scripts/prepare.sh
# Add multiverse repository
add-apt-repository -y multiverse
add-apt-repository -y universe
add-apt-repository -y restricted
apt-get update -o DPkg::Lock::Timeout=-1

# Install system packages
apt-get install -o DPkg::Lock::Timeout=-1 -y build-essential pwgen whois zstd software-properties-common

## Install HTTPS support for APT.
apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends apt-transport-https ca-certificates

## Fix locale. (Why?)
apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends language-pack-en

locale-gen en_US
update-locale LANG=en_US.UTF-8 LC_CTYPE=en_US.UTF-8

# Install other common scripts.
apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends \
    tini gosu curl wget tar zip unzip git rsync tzdata gpg-agent openssh-client openssl
