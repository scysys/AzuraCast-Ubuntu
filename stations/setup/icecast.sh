#!/usr/bin/env bash

# Install required packages for building Icecast
apt_get_with_lock update
apt_get_with_lock install -y --no-install-recommends \
  build-essential libxml2 libxslt1-dev libvorbis-dev libssl-dev libcurl4-openssl-dev openssl

# Download and extract the Icecast source code
curl -fsSL -o icecast.tar.gz https://github.com/AzuraCast/icecast-kh-ac/archive/refs/tags/2.4.0-kh15-ac2.tar.gz
mkdir /tmp/icecast && tar -xzvf icecast.tar.gz --strip-components=1 -C /tmp/icecast

# Build and install Icecast
cd /tmp/icecast
./configure
make
make install

# Clean up the Icecast source code and any unnecessary packages
rm -rf /tmp/icecast

# Go back to the installer home directory
cd $installerHome
