#!/usr/bin/env bash

# Audio library dependencies used by Php-Getid3
apt_get_with_lock update && apt_get_with_lock install -y --no-install-recommends vorbis-tools flac
