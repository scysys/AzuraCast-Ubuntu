#!/usr/bin/env bash

# Add the audiowaveform PPA repository
add-apt-repository -y ppa:chris-needham/ppa

# Update package list
apt_get_with_lock update

# Install audiowaveform without recommended packages and with unlimited timeout
apt_get_with_lock install --no-install-recommends -y audiowaveform
