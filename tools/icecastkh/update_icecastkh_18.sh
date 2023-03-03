#!/usr/bin/env bash

# Stop anything
supervisorctl stop all || :

# Download and extract the Icecast source code
curl -fsSL -o icecast.tar.gz https://github.com/karlheyes/icecast-kh/archive/refs/tags/icecast-2.4.0-kh18.tar.gz
mkdir /tmp/icecast && tar -xzvf icecast.tar.gz --strip-components=1 -C /tmp/icecast

# Build and install Icecast
cd /tmp/icecast
./configure
make
make install

# Go back to the installer home directory
cd $installerHome

# Clean up the Icecast source code and any unnecessary packages
rm -rf /tmp/icecast

# Start anything
supervisorctl start all || :
