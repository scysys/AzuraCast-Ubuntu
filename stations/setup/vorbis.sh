#!/usr/bin/env bash

# Update the package lists and install the necessary dependencies
apt-get update
apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends vorbis-tools
