#!/usr/bin/env bash

# Stop anything
supervisorctl stop all || :

# Download the latest version of Icecast from the master branch
curl -fsSL -o icecast.tar.gz https://github.com/karlheyes/icecast-kh/archive/master.tar.gz
mkdir /tmp/icecast && tar -xzvf icecast.tar.gz --strip-components=1 -C /tmp/icecast

# Build and install Icecast
cd /tmp/icecast
./configure
make
make install

# Go back to the installer home directory
cd $installerHome

# Clean up the Icecast source code and any unnecessary packages
rm -rf /tmp/icecast* icecast.tar.gz

# Start anything
supervisorctl start all || :
