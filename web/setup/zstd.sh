#!/usr/bin/env bash

apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends zstd
