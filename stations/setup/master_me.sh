#!/usr/bin/env bash

# Create a working directory
WORK_DIR="/tmp/master_me"

# Create the target directory if it doesn't exist
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

# Get the system architecture using dpkg and awk
ARCHITECTURE=$(dpkg --print-architecture | awk -F- '{ print $NF }')

# Construct the download URL
DOWNLOAD_URL="https://github.com/trummerschlunk/master_me/releases/download/1.2.0/master_me-1.2.0-linux-${ARCHITECTURE}.tar.xz"

# Download the package
wget -O master_me.tar.xz "$DOWNLOAD_URL"

# Extract the package
tar -xvf master_me.tar.xz --strip-components=1

# Create directories for installation if they don't exist
mkdir -p /usr/lib/ladspa
mkdir -p /usr/lib/lv2

# Move the extracted files to their respective locations
mv ./master_me-easy-presets.lv2 /usr/lib/lv2
mv ./master_me.lv2 /usr/lib/lv2
mv ./master_me-ladspa.so /usr/lib/ladspa/master_me.so

# Return to the installer home directory
cd $installerHome

# Clean up the temporary directory
rm -rf "$WORK_DIR"
