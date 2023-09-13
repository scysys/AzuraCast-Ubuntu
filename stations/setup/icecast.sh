#!/usr/bin/env bash

# Install required packages for building Icecast
apt_get_with_lock update
apt_get_with_lock install -y --no-install-recommends \
  build-essential libxml2 libxslt1-dev libvorbis-dev libssl-dev libcurl4-openssl-dev openssl

# Create a working directory
WORK_DIR="/tmp/icecast"
mkdir -p "$WORK_DIR"

# Download and extract the Icecast source code
curl -fsSL -o "$WORK_DIR/icecast.tar.gz" https://github.com/karlheyes/icecast-kh/archive/refs/tags/icecast-2.4.0-kh22.tar.gz
tar -xzvf "$WORK_DIR/icecast.tar.gz" --strip-components=1 -C "$WORK_DIR"

# Build and install Icecast
cd "$WORK_DIR"
./configure
make
make install

# Do customizations
CUSTOM_DIR="$WORK_DIR/icecast_customizations"
mkdir -p "$CUSTOM_DIR"
curl -fsSL -o "$CUSTOM_DIR/custom-files.tar.gz" https://github.com/AzuraCast/icecast-kh-custom-files/archive/refs/tags/2023-04-23.tar.gz
tar -xvzf "$CUSTOM_DIR/custom-files.tar.gz" --strip-components=1 -C "$CUSTOM_DIR"

cp -r "$CUSTOM_DIR/web/"* /usr/local/share/icecast/web/

# Return to the installer home directory
cd $installerHome

# Remove the working directory
rm -rf "$WORK_DIR"
