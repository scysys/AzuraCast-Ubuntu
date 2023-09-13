#!/usr/bin/env bash

# Function to check for dpkg lock and wait until it's released or timeout occurs
wait_for_dpkg_lock() {
    local timeout=120
    local start_time=$(date +%s)
    while pgrep -f 'dpkg\.lock-frontend|apt' >/dev/null; do
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
