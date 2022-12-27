#!/usr/bin/env bash

add-apt-repository -y ppa:chris-needham/ppa
apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends audiowaveform
