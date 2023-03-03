#!/usr/bin/env bash

# Define the function to check if a variable is numeric
function is_numeric() {
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        return 0 # The variable is numeric
    else
        return 1 # The variable is not numeric
    fi
}

# Prompt the user to enter the HTTP and HTTPS ports
read -rp "Enter HTTP Port: " azuracast_http_port
read -rp "\nEnter HTTPS Port: " azuracast_https_port

# Check if both variables are numeric using the is_numeric function
if is_numeric "$azuracast_http_port" && is_numeric "$azuracast_https_port"; then
    echo "\nHTTP Port: $azuracast_http_port"
    echo "\nHTTPS Port: $azuracast_https_port"
else
    echo "\nError: Please enter a valid number for HTTP and HTTPS ports."
    exit 1
fi

# Stop anything
supervisorctl stop nginx || :

# Get Original Template
cp -f $installerHome/web/nginx/azuracast.conf /etc/nginx/sites-available/azuracast.conf

# Change nginx.conf
sed -i "s/listen 80/listen $azuracast_http_port/g" /etc/nginx/sites-available/azuracast.conf
sed -i "s/listen 443/listen $azuracast_http_port/g" /etc/nginx/sites-available/azuracast.conf

# Start anything
supervisorctl start nginx || :
