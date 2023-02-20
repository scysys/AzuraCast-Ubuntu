#!/usr/bin/env bash

# Set the URL for the n installation script
N_INSTALLER_URL=https://raw.githubusercontent.com/tj/n/master/bin/n

# Update package lists and install dependencies
apt-get update
apt-get install -o DPkg::Lock::Timeout=-1 -y curl

# Download and run the n installation script to install Node.js LTS version
curl -L $N_INSTALLER_URL | bash -s -- -L lts

# Clean up by removing the n installation script
rm -f n_installer
