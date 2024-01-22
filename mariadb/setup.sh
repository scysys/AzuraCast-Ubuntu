#!/usr/bin/env bash

##############################################################################
# setup_mariadb
##############################################################################

# It seems that Azuracat is actually need MariaDB 10.9? Actual default Ubuntu version is 10.6
apt_get_with_lock install -y wget software-properties-common dirmngr ca-certificates apt-transport-https

if [ $azuracast_git_version = "stable" ]; then
    curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version="mariadb-$set_mariadb_version"
else
    apt_get_with_lock install software-properties-common gnupg2 -y
    apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'

    echo "# MariaDB Server
# To use a different major version of the server, or to pin to a specific minor version, change URI below.
deb [arch=amd64,arm64] https://dlm.mariadb.com/repo/mariadb-server/10.8/repo/ubuntu jammy main

deb [arch=amd64,arm64] https://dlm.mariadb.com/repo/mariadb-server/10.8/repo/ubuntu jammy main/debug


# MariaDB MaxScale
# To use the latest stable release of MaxScale, use "latest" as the version
# To use the latest beta (or stable if no current beta) release of MaxScale, use "beta" as the version
deb [arch=amd64,arm64] https://dlm.mariadb.com/repo/maxscale/latest/apt jammy main


# MariaDB Tools
deb [arch=amd64] http://downloads.mariadb.com/Tools/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/mariadb.list

    apt_get_with_lock update -y
fi

apt_get_with_lock install -y mariadb-server mariadb-client

# Create AzuraCast DB
mysql -e "create database $set_azuracast_database character set utf8mb4 collate utf8mb4_bin;"
mysql -e "create user $set_azuracast_username@localhost identified by '$set_azuracast_password';"
mysql -e "grant all privileges on $set_azuracast_database.* to $set_azuracast_username@localhost;"

# Prepare MySQL-Root-Password
if [ $azuracast_git_version = "stable" ]; then
    sed -i "s/changeToMySQLRootPW/$mysql_root_pass/g" mariadb/config/mysql_secure_installation.sql

    # Secure MySQL in same way like: mysql_secure_installation
    mysql -sfu root <"mariadb/config/mysql_secure_installation.sql"
else
    echo "do nothing, will do it later in another way"
fi

# Because of AzuraCasts Supervisor Integration
systemctl disable mariadb
systemctl stop mariadb
