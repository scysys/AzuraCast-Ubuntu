#!/usr/bin/env bash

# Define a function to install a package without running its post-installation script
install_without_postinst() {
    local PACKAGE=$1
    local TMP_DIR="/tmp/install_$PACKAGE"
    mkdir -p "$TMP_DIR"
    pushd "$TMP_DIR"
    apt_get_with_lock download "$PACKAGE"
    dpkg --unpack "$PACKAGE"*.deb
    rm -f /var/lib/dpkg/info/"$PACKAGE".postinst
    dpkg --configure "$PACKAGE"
    apt_get_with_lock install -yf # To fix dependencies
    popd
}

# Install netbase package without recommended packages
apt_get_with_lock install --no-install-recommends -y netbase

# Install beanstalkd package without running its post-installation script
install_without_postinst beanstalkd

# Go back to the installer home directory
cd $installerHome
