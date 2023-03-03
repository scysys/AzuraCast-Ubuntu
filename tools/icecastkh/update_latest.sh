#!/usr/bin/env bash

# Stop anything
supervisorctl stop all || :

# Get the latest release tag name for Icecast
tag_name=$(curl -s https://api.github.com/repos/karlheyes/icecast-kh/releases/latest | grep "tag_name" | cut -d '"' -f 4)

# Construct the release URL for Icecast
release_url="https://github.com/karlheyes/icecast-kh/archive/refs/tags/$tag_name.zip"

# Download and extract the Icecast source code
curl -fsSL -o icecast.zip "$release_url"
unzip icecast.zip -d /tmp/
cd /tmp/icecast-kh*

# Build and install Icecast
./configure
make
make install

# Go back to the installer home directory
cd $installerHome

# Clean up the Icecast source code and any unnecessary packages
rm -rf /tmp/icecast-kh* icecast.zip

# Start anything
supervisorctl start all || :
