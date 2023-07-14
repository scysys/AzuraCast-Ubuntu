#!/usr/bin/env bash

# Loop that repeats the apt-get command until the lock file is released
# It must be double here, because i include this file in other script directly.
while fuser /var/lib/dpkg/lock >/dev/null 2>&1; do
  echo 'Lock file is in use. Waiting 3 seconds...'
  sleep 3
done

##############################################################################
# AzuraCast Installer / DO NOT USE THIS OPTION
##############################################################################

cat <<EOF
***************************************************************************
            AzuraCast $set_azuracast_version Installation
***************************************************************************

For more verbose logs, open up a second terminal and use the following command:

tail -f $installerHome/azuracast_installer.log
EOF

echo -en "
***********************************************************************
You used the install option --install_scyonly.
This install option will not work on your side.

Please use --install to install AzuraCast's latest Stable Release $set_azuracast_version.
***********************************************************************

"

# prepare_system
echo -en "\n- 1/11 prepare_system\n"
source misc/prepare_system.sh &>>"${LOG_FILE}"

# setup_azuracast_user
echo -en "\n- 2/11 setup_azuracast_user\n"
source azuracast/user.sh &>>"${LOG_FILE}"

# setup_mariadb
echo -en "\n- 3/11 setup_mariadb\n"
source mariadb/setup.sh &>>"${LOG_FILE}"

# setup_stations
echo -en "\n- 4/11 setup_stations\n"
source stations/setup.sh &>>"${LOG_FILE}"

# setup_web
echo -en "\n- 5/11 setup_web\n"
source web/setup.sh &>>"${LOG_FILE}"

# setup_sftpgo
echo -en "\n- 6/11 setup_sftpgo\n"
source sftpgo/setup.sh &>>"${LOG_FILE}"

# setup_redis
echo -en "\n- 7/11 setup_redis\n"
source redis/setup.sh &>>"${LOG_FILE}"

# setup_supervisor
echo -en "\n- 8/11 setup_supervisor\n"
source supervisor/setup.sh &>>"${LOG_FILE}"

# setup_azuracast_install
echo -en "\n- 9/11 setup_azuracast_install\n"
source azuracast/install.sh &>>"${LOG_FILE}"

# Just check permissions again
echo -en "\n- 10/11 Set AzuraCast Permissions\n"
chown -R azuracast.azuracast /var/azuracast &>>"${LOG_FILE}"

# Update and Upgrade System again
echo -en "\n- 11/11 Set AzuraCast Permissions\n"
source misc/finalize.sh &>>"${LOG_FILE}"

echo -en "
***************************************************************************
  MySQL Details
  - MySQL "AzuraCast" DB Name: $set_azuracast_database
  - MySQL "AzuraCast" DB User: $set_azuracast_username
  - MySQL "AzuraCast" DB Password: $set_azuracast_password
***************************************************************************\n
" | tee /root/credentials/credentials_azuracast.txt

echo -en "\n- End - Forward with main installer\n"
