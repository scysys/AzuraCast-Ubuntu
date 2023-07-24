#!/usr/bin/env bash

# Update the package lists and install the necessary dependencies
apt_get_with_lock update
apt_get_with_lock install -y --no-install-recommends flac
