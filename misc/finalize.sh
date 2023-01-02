#!/usr/bin/env bash

##############################################################################
# finalize
##############################################################################

apt-get update -o DPkg::Lock::Timeout=-1
apt-get upgrade -o DPkg::Lock::Timeout=-1 -y
