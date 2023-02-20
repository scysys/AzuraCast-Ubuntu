#!/usr/bin/env bash

# Install the zstd package without recommended packages
apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends zstd
