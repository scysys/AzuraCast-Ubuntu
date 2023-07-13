#!/usr/bin/env bash

##############################################################################
# AzuraCast Installer / Default, Latest Stable
##############################################################################

cat <<EOF
***********************************************************************
            AzuraCast $set_azuracast_version Installation
***********************************************************************

For more verbose logs, open up a second terminal and use the following command:

tail -f $installerHome/azuracast_installer.log
EOF

echo -en "
***********************************************************************
Please be aware: do not interrupt the installation process.
Sit back, relax, and avoid pressing any keys on your keyboard!

Depending on your system, the installation may take around 25 minutes or more.

Also, please remember: if any single process fails, you should reinstall your system with Ubuntu 22.04 and try again!
This installer may not support any of your preinstalled third-party software.
***********************************************************************
"

# User should read above. So lets wait.
sleep 6

# ask_for_settings
source misc/ask_for_settings.sh

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

# setup_azuracast_install
echo -en "\n- 8/11 setup_azuracast_install\n"
source azuracast/install.sh &>>"${LOG_FILE}"

# Just check permissions again
echo -en "\n- 9/11 Set AzuraCast Permissions\n"
chown -R azuracast.azuracast /var/azuracast &>>"${LOG_FILE}"

# setup_supervisor
echo -en "\n- 10/11 setup_supervisor\n"
source supervisor/setup.sh &>>"${LOG_FILE}"

# Update and Upgrade System again
echo -en "\n- 11/11 Set AzuraCast Permissions\n"
source misc/finalize.sh &>>"${LOG_FILE}"

echo -en "
***************************************************************************
Whup! Whup! AzuraCast Installation is complete.
  - The server will be accessible at at http://$user_hostname

  - MySQL "root" User: root
  - MySQL "root" Password: $mysql_root_pass

  - MySQL "AzuraCast" DB Name: $set_azuracast_database
  - MySQL "AzuraCast" DB User: $set_azuracast_username
  - MySQL "AzuraCast" DB Password: $set_azuracast_password

Please do not disturb the AzuraCast Team with errors in this Installer.
The Developers only support the Docker variant!

If needed, you will find a log of your installations process here: $installerHome/azuracast_installer.log
Your credentials where also saved to: $installerHome/azuracast_details.txt
You should delete the Install folder now: $installerHome

Because of Updates, some service restarts and maybe also Kernel ones.
YOU MUST REBOOT NOW OR YOU WILL GET ERROR 500!
***************************************************************************\n
" | tee $installerHome/azuracast_details.txt
