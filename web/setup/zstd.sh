#!/usr/bin/env bash

# Install the zstd package without recommended packages
apt_get_with_lock install -y --no-install-recommends zstd
