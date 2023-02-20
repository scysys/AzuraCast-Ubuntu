#!/usr/bin/env bash

# Add the audiowaveform PPA repository
add-apt-repository -y ppa:chris-needham/ppa

# Update package list
apt-get update

# Install audiowaveform without recommended packages and with unlimited timeout
apt-get install -o DPkg::Lock::Timeout=-1 --no-install-recommends -y audiowaveform
