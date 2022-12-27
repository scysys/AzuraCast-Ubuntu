#!/usr/bin/env bash

### Description: Install Azuracast
### OS: Ubuntu 22.04 LTS
### Run this script as root only
### mkdir /root/azuracast_installer && cd /root/azuracast_installer && git clone https://github.com/scysys/AzuraCast-Ubuntu.git . && chmod +x install.sh && ./install.sh -i

##############################################################################
# Azuracast Installer
##############################################################################

set -eu -o errexit -o pipefail -o noclobber -o nounset

! getopt --test >/dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo '`getopt --test` failed in this environment.'
    exit 1
fi

### Installer options
# Installer home
installerHome=$PWD

# PHP
set_php_version=8.1

# MariaDB
# MariaDB "root" Password
mysql_root_pass=$(
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16
    echo ''
)

set_mariadb_version=10.9

# Azuracast
generate_azuracast_username=$(
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16
    echo ''
)

generate_azuracast_password=$(
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16
    echo ''
)

# AzuraCast Database cant be custom. Migrate function does actually not respect different database names.
set_azuracast_database=azuracast
set_azuracast_username=$generate_azuracast_username
set_azuracast_password=$generate_azuracast_password

# TODO: Use this for Updater integration
set_azuracast_version=0.0.1
set_installer_version=0.0.1

# Commands
LONGOPTS=help,version,upgrade,install
OPTIONS=hvui

if [ "$#" -eq 0 ]; then
    echo "No options specified. Use --help to learn more."
    exit 1
fi

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi

eval set -- "$PARSED"

d=n h=n v=n u=n p=n

while true; do
    case "$1" in
    -h | --help)
        h=y
        break
        ;;
    -v | --version)
        v=y
        shift
        ;;
    -u | --upgrade)
        u=y
        break
        ;;
    -i | --install)
        i=y
        break
        ;;
    --)
        shift
        break
        ;;
    *)
        echo "Invalid option(s) specified. Use help(-h) to learn more."
        exit 3
        ;;
    esac
done

if [ "$(id -u)" -ne 0 ]; then
    echo 'This needs to be run as root.' >&2
    exit 1
fi

### Wait for APT: Not in use. Maybe better variant than -o DPkg::Lock::Timeout=-1
wait_for_apt_lock() {
    apt_lock=/var/lib/dpkg/lock-frontend
    if [ -f "$apt_lock" ]; then
        echo "$apt_lock exists. So lets wait a little bit."
        sleep 6
        # Start new
        wait_for_apt_lock
    else
        echo "$apt_lock not exists."
    fi
}

trap exit_handler EXIT

##############################################################################
# Invoked upon EXIT signal from bash
##############################################################################
function exit_handler() {
    if [ "$?" -ne 0 ]; then
        echo -en "\nSome error has occured. Check '$installerHome/azuracast_installer.log' for details.\n"
        #echo -en "\nThe current working directory: $PWD\n\n"
        exit 1
    fi
}

##############################################################################
# Setup Installer Logging
##############################################################################
function azuracast_installer_logging() {
    touch $installerHome/azuracast_installer.log
    LOG_FILE="$installerHome/azuracast_installer.log"
}

##############################################################################
# Print help (-h/--help)
##############################################################################
function azuracast_help() {
    echo "TODO: Azuracast Help"
    exit 0
}

##############################################################################
# Print version (-v/--version)
##############################################################################
function azuracast_version() {
    echo "TODO: Azuracast Version"
    exit 0
}

##############################################################################
# Upgrade an existing installation to latest stable version of Azuracast (-u/--upgrade)
##############################################################################
function azuracast_upgrade() {
    echo "TODO: Azuracast Upgrade"
    exit 0
}

##############################################################################
# Install the latest stable version of Azuracast (-i/--install)
##############################################################################
function azuracast_install() {
    source install_default.sh
}

##############################################################################
# main function that handles the control flow
##############################################################################
function main() {
    azuracast_installer_logging

    if [ "$h" == "y" ]; then
        azuracast_help
    fi

    if [ "$v" == "y" ]; then
        azuracast_version
    fi

    if [ "$u" == "y" ]; then
        azuracast_upgrade
    fi

    if [ "$i" == "y" ]; then
        azuracast_installer_logging

        # Its ok if we do it once here. It will work for all other parts as long as the installer runs and is gone after reboot.
        export DEBIAN_FRONTEND=noninteractive

        azuracast_install
    fi

}

main "$@"