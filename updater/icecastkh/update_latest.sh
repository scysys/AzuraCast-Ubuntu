#!/usr/bin/env bash

# Stop anything
supervisorctl stop all || :

# Get the latest release URL for Icecast
release_url=$(curl -s https://api.github.com/repos/karlheyes/icecast-kh/releases/latest | grep "browser_download_url.*icecast.*tar.gz" | cut -d : -f 2,3 | tr -d \")

# Download and extract the Icecast source code
curl -fsSL -o icecast.tar.gz "$release_url"
mkdir /tmp/icecast && tar -xzvf icecast.tar.gz --strip-components=1 -C /tmp/icecast

# Build and install Icecast
cd /tmp/icecast
./configure
make
make install

# Clean up the Icecast source code and any unnecessary packages
rm -rf /tmp/icecast

# Start anything
supervisorctl start all || :

# Go back to the installer home directory
cd $installerHome
