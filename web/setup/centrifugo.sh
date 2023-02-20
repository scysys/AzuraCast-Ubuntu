#!/usr/bin/env bash

# Set variables for the golang version and centrifugo URL
GOLANG_VERSION=1.18
CENTRIFUGO_URL=https://github.com/centrifugal/centrifugo/archive/d465b5932ab786273f081392e1dc8fdfd2d2ec10.tar.gz

# Update the package lists and install the necessary dependencies
apt-get update
apt-get install -o DPkg::Lock::Timeout=-1 -y curl tar gzip ca-certificates

# Download and install golang
curl -fsSL https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz | tar -C /usr/local -xz

# Set the necessary environment variables for golang
export PATH=$PATH:/usr/local/go/bin
export GOPATH=$HOME/go

# Download and extract the centrifugo source code
curl -fsSL $CENTRIFUGO_URL | tar -C /usr/local -xz
mv /usr/local/centrifugo* /usr/local/centrifugo

# Build and install centrifugo
cd /usr/local/centrifugo
go build -o /usr/local/bin/centrifugo .

# Copy the centrifugo configuration file to the AzuraCast directory
cp $installerHome/web/centrifugo/config.json /var/azuracast/centrifugo/

# Clean up by removing the go directory
rm -rf $GOPATH
rm -rf /usr/local/go

# Go back to the installer home directory
cd $installerHome
