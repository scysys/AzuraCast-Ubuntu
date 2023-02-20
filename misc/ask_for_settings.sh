#!/usr/bin/env bash

# Ask the user for their domain/subdomain for AzuraCast
read -rp "Enter your domain/subdomain for AzuraCast (e.g. mydomain.com or subdomain.domain.com): " user_hostname

# Check if the user has entered a valid hostname
if [ -n "$user_hostname" ]; then
    echo "Hostname set to $user_hostname."
    #hostname "$user_hostname"
else
    echo "No hostname provided. Installation aborted."
    exit 1
fi
