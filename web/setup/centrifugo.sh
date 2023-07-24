#!/usr/bin/env bash

# Install the Golang package without recommended packages
apt_get_with_lock install -y --no-install-recommends golang

# Install a specific version of Centrifugo using Go
go install github.com/centrifugal/centrifugo/v4@d465b5932ab786273f081392e1dc8fdfd2d2ec10

# Move the centrifugo binary to /usr/local/bin
mv /root/go/bin/centrifugo /usr/local/bin/centrifugo

# Remove the Go installation directory
rm -rf /root/go

# Copy the Centrifugo configuration file to the appropriate directory
cp web/centrifugo/config.json /var/azuracast/centrifugo/config.json
