#!/usr/bin/env bash

# Stop anything
supervisorctl stop all || :

# Get the latest release tag name for Icecast
tag_name=$(curl -s https://api.github.com/repos/savonet/liquidsoap-release-assets/releases/latest | grep "tag_name" | cut -d '"' -f 4 | sed 's/v//')

# Construct the release URL for Icecast
ARCHITECTURE=$(dpkg --print-architecture | awk -F- '{ print $NF }')
release_url="https://github.com/savonet/liquidsoap-release-assets/releases/download/v2.2.1/liquidsoap_$tag_name-ubuntu-jammy-1_$ARCHITECTURE.deb"

# Download the latest Liquidsoap .deb package
curl -LO "$release_url"

# Install Liquidsoap and its dependencies
dpkg -i liquidsoap_$tag_name-ubuntu-jammy-1_$ARCHITECTURE.deb

# Update package list
apt_get_with_lock update

# Upgrade Liquidsoap and its dependencies
apt_get_with_lock upgrade -y liquidsoap

# Clean up
rm liquidsoap_$tag_name-ubuntu-jammy-1_$ARCHITECTURE.deb

# Start anything
supervisorctl start all || :
