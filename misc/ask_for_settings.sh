#!/usr/bin/env bash

##############################################################################
# ask_for_settings
##############################################################################

### Ask User for Hostname
read -rp 'Enter your Domain/Subdomain for AzuraCast (e.g., mydomain.com or subdomain.domain.com): ' user_hostname

if [ "$user_hostname" != "" ]; then
    echo -en "We received your Hostname: $user_hostname\n"
    #hostname $user_hostname
fi

if [ "$user_hostname" == "" ]; then
    echo -en "\n-You have NOT entered a Hostname. Installation aborted!\n"
    exit 0
fi
