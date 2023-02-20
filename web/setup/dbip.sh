#!/usr/bin/env bash

# Set variables for the dbip directory and database file
DBIP_DIR=/var/azuracast/dbip
DBIP_FILE=dbip-city-lite.mmdb

# Create the dbip directory if it doesn't exist
mkdir -p $DBIP_DIR

# Set the year and month variables based on the current date
YEAR=$(date +'%Y')
MONTH=$(date +'%m')

# Download the latest version of the dbip-city-lite database file and extract it
curl -sSfL "https://download.db-ip.com/free/dbip-city-lite-${YEAR}-${MONTH}.mmdb.gz" | gunzip -c >"$DBIP_DIR/$DBIP_FILE"

# Set the correct permissions for the database file and directory
chmod 0644 "$DBIP_DIR/$DBIP_FILE"
chown -R azuracast:azuracast $DBIP_DIR
