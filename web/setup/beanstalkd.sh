#!/usr/bin/env bash

install_without_postinst() {
    local PACKAGE
    PACKAGE=$1

    mkdir -p bd_build/install_$PACKAGE
    cd bd_build/install_$PACKAGE

    apt-get download $PACKAGE -o DPkg::Lock::Timeout=-1
    dpkg --unpack $PACKAGE*.deb
    rm -f /var/lib/dpkg/info/$PACKAGE.postinst
    dpkg --configure $PACKAGE

    apt-get install -o DPkg::Lock::Timeout=-1 -yf #To fix dependencies
}

apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends netbase

install_without_postinst beanstalkd

cd $installerHome
