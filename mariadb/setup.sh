#!/usr/bin/env bash

##############################################################################
# setup_mariadb
##############################################################################

# It seems that Azuracat is actually need MariaDB 10.9? Actual default Ubuntu version is 10.6
apt-get install -o DPkg::Lock::Timeout=-1 -y wget software-properties-common dirmngr ca-certificates apt-transport-https

curl -LsS https://r.mariadb.com/downloads/mariadb_repo_setup | sudo bash -s -- --mariadb-server-version="mariadb-$set_mariadb_version"

apt-get install -o DPkg::Lock::Timeout=-1 -y mariadb-server mariadb-client

# Create AzuraCast DB
mysql -e "create database $set_azuracast_database character set utf8mb4 collate utf8mb4_bin;"
mysql -e "create user $set_azuracast_username@localhost identified by '$set_azuracast_password';"
mysql -e "grant all privileges on $set_azuracast_database.* to $set_azuracast_username@localhost;"

# Prepare MySQL-Root-Password
if [ $azuracast_git_version = "stable" ]; then
    sed -i "s/changeToMySQLRootPW/$mysql_root_pass/g" mariadb/config/mysql_secure_installation.sql
else
    echo "do nothing, will do it later in another way"
fi

# Secure MySQL in same way like: mysql_secure_installation
mysql -sfu root <"mariadb/config/mysql_secure_installation.sql"

# Because of AzuraCasts Supervisor Integration
systemctl disable mariadb
systemctl stop mariadb
