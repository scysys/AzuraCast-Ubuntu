#!/usr/bin/env bash

### Description: Install AzuraCast
### OS: Ubuntu 22.04 LTS
### Run this script as root only
### mkdir /root/azuracast_installer && cd /root/azuracast_installer && git clone https://github.com/scysys/AzuraCast-Ubuntu.git . && chmod +x install.sh && ./install.sh -i

##############################################################################
# AzuraCast Installer
##############################################################################

set -eu -o errexit -o pipefail -o noclobber -o nounset

! getopt --test >/dev/null
if [[ ${PIPESTATUS[0]} -ne 4 ]]; then
    echo '`getopt --test` failed in this environment.'
    exit 1
fi

# Generate random passwords
mysql_root_pass=$(
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16
    echo ''
)

generate_azuracast_username=$(
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16
    echo ''
)

generate_azuracast_password=$(
    head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16
    echo ''
)

### Global Installer Options
# Installer Home
installerHome=$PWD

# Misc Options
set_php_version=8.2

# AzuraCast Database cant be custom. Migrate function does actually not respect different database names.
set_azuracast_database=azuracast
set_azuracast_username=$generate_azuracast_username
set_azuracast_password=$generate_azuracast_password

# Show AzuraCast and Installer Version
set_azuracast_version=0.18.5

# Commands
LONGOPTS=help,version,upgrade,install,install_scyonly,upgrade_scyonly,icecastkh18,icecastkhlatest,icecastkhmaster,changeports,liquidsoaplatest,liquidsoapcustom
OPTIONS=hvuixywtsonm

if [ "$#" -eq 0 ]; then
    echo "No options specified. Use --help to learn more."
    exit 1
fi

! PARSED=$(getopt --options=$OPTIONS --longoptions=$LONGOPTS --name "$0" -- "$@")
if [[ ${PIPESTATUS[0]} -ne 0 ]]; then
    exit 2
fi

eval set -- "$PARSED"

h=n v=n u=n i=n x=n y=n w=n t=n s=n o=n n=n m=n

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
    -x | --install_scyonly)
        x=y
        break
        ;;
    -y | --upgrade_scyonly)
        y=y
        break
        ;;
    -w | --icecastkh18)
        w=y
        break
        ;;
    -t | --icecastkhlatest)
        t=y
        break
        ;;
    -s | --icecastkhmaster)
        s=y
        break
        ;;
    -o | --changeports)
        o=y
        break
        ;;
    -n | --liquidsoaplatest)
        n=y
        break
        ;;
    -m | --liquidsoapcustom)
        m=y
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

trap exit_handler EXIT

# Function to check for dpkg lock and wait until it's released or timeout occurs
wait_for_dpkg_lock() {
    local timeout=120
    local start_time=$(date +%s)
    while pgrep -f 'dpkg\.lock-frontend' >/dev/null; do
        local current_time=$(date +%s)
        local elapsed_time=$((current_time - start_time))
        if ((elapsed_time >= timeout)); then
            echo "Timeout: Unable to acquire dpkg lock after $timeout seconds. Exiting..."
            exit 1
        fi
        echo 'Lock file is in use. Waiting 3 seconds...'
        sleep 3
    done
}

# Wrapper function for apt-get that handles the lock check
apt_get_with_lock() {
    wait_for_dpkg_lock
    apt-get "$@"
}

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
# Tools: Update to Icecast KH 18
##############################################################################
function tools_update_icecastkh_18() {
    source tools/icecastkh/update_icecastkh_18.sh
}

##############################################################################
# Tools: Update to Icecast KH Latest
##############################################################################
function tools_update_icecastkh_latest() {
    source tools/icecastkh/update_latest.sh
}

##############################################################################
# Tools: Update to Icecast KH Master Branch
##############################################################################
function tools_update_icecastkh_master() {
    source tools/icecastkh/update_master.sh
}

##############################################################################
# Tools: Change AzuraCast Ports
##############################################################################
function toosl_change_azuracast_ports() {
    source tools/azuracast/change_ports.sh
}

##############################################################################
# Tools: Liquidsoap Latest
##############################################################################
function tools_update_liquidsoap() {
    source tools/liquidsoap/update_latest.sh
}

##############################################################################
# Tools: Liquidsoap Custom
##############################################################################
function tools_update_liquidsoap_custom() {
    source tools/liquidsoap/update_custom.sh
}

##############################################################################
# Print help (-h/--help)
##############################################################################
function azuracast_help() {
    cat <<EOF
---
Install and manage your AzuraCast installation.

Attention
I have not tested using multiple commands at the same time.
If you need to use another command from here stay safe and execute them one by one.

Installation / Upgrade
  -i, --install                  Install the latest stable version of AzuraCast
  -u, --upgrade                  Upgrade to the latest stable version of AzuraCast
  -v, --version                  Display version information
  -h, --help                     Display this help text
  
Azuracast

  -o, --changeports              Change the Ports on which AzuraCast Panel itself is running

Icecast KH

  -w, --icecastkh18              Install / Update to Icecast KH 18
  -t, --icecastkhlatest          Install / Update to latest Icecast KH build on GitHub
  -s, --icecastkhmaster          Install / Update to latest Icecast KH based on the actual master branch

Liquidsoap

  -n, --liquidsoaplatest         Install / Update to the latest released Liquidsoap Version
  -m, --liquidsoapcustom         Install / Update to a Liquidsoap Version that the user will enter

Exit status:
Returns 0 if successful; non-zero otherwise.
---
EOF
}

##############################################################################
# Print version (-v/--version)
##############################################################################
function azuracast_version() {

    echo "---
Available AzuraCast Version: $set_azuracast_version"

    azv=/var/azuracast/www/src/Version.php
    if [ -f "$azv" ]; then
        FALLBACK_VERSION="$(grep -oE "\FALLBACK_VERSION = .*;" $azv | sed "s/FALLBACK_VERSION = '//g;s/';//g")"
        echo -en "Installed AzuraCast Version: $FALLBACK_VERSION \n\n"
    else
        echo -en "\nAzuraCast is actually not installed.\n---\n"
    fi
}

##############################################################################
# Install the latest stable version of AzuraCast (-i/--install)
##############################################################################
function azuracast_install() {
    azuracast_git_version="stable"

    export DEBIAN_FRONTEND=noninteractive

    # Options
    set_mariadb_version=10.9

    # Include source
    source install_default.sh
}

##############################################################################
# Upgrade an existing installation to latest stable version of AzuraCast (-u/--upgrade)
##############################################################################
function azuracast_upgrade() {
    ### Update Installer
    git stash && git pull

    # Move any stashed changes to a temporary branch
    git stash branch temp_branch

    git checkout 0.18.5 && chmod +x install.sh

    source tools/azuracast/update/0176_0185.sh

    # Remove the temporary branch if it exists
    git branch -D temp_branch

    echo -e "Do Reboot NOW!"
}

##############################################################################
# Do not Use! (-x/--install_scyonly)
##############################################################################
function azuracast_install_scyonly() {
    azuracast_git_version="blub"

    export DEBIAN_FRONTEND=noninteractive

    # Options
    set_mariadb_version=10.8

    # Include source
    source install_scyonly.sh
}

##############################################################################
# Do not Use! (-x/--upgrade_scyonly)
##############################################################################
function azuracast_upgrade_scyonly() {
    echo "TODO: AzuraCast Upgrade"
    exit 0
    #source upgrade_scyonly.sh
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

    if [ "$i" == "y" ]; then
        azuracast_install
    fi

    if [ "$u" == "y" ]; then
        azuracast_upgrade
    fi

    if [ "$x" == "y" ]; then
        azuracast_install_scyonly
    fi

    if [ "$y" == "y" ]; then
        azuracast_upgrade_scyonly
    fi

    if [ "$w" == "y" ]; then
        tools_update_icecastkh_18
    fi

    if [ "$t" == "y" ]; then
        tools_update_icecastkh_latest
    fi

    if [ "$s" == "y" ]; then
        tools_update_icecastkh_master
    fi

    if [ "$o" == "y" ]; then
        toosl_change_azuracast_ports
    fi

    if [ "$n" == "y" ]; then
        tools_update_liquidsoap
    fi

    if [ "$m" == "y" ]; then
        tools_update_liquidsoap_custom
    fi

}

main "$@"
