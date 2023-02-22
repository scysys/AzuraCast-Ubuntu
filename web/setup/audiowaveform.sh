#!/usr/bin/env bash

# Add the audiowaveform PPA repository
add-apt-repository -y ppa:chris-needham/ppa

# Update package list
apt-get update

# Install audiowaveform without recommended packages and with unlimited timeout
apt-get install --no-install-recommends -y audiowaveform
