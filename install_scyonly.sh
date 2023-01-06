#!/usr/bin/env bash

##############################################################################
# Azuracast Installer / DO NOT USE THIS OPTION
##############################################################################

cat <<EOF
***************************************************************************
                        Azuracast Installation
***************************************************************************

For more verbose logs, open up a second terminal and use the following command:

tail -f $installerHome/azuracast_installer.log
EOF

echo -en "
***************************************************************************
You used the install option --install_scyonly.
This install option will not work on your side.

Please use --install to install AzuraCast´s latest Stable Release $set_azuracast_version. 
***************************************************************************

"

# prepare_system
echo -en "\n- 1/10 prepare_system\n"
source misc/prepare_system.sh &>>"${LOG_FILE}"

# setup_azuracast_user
echo -en "\n- 2/10 setup_azuracast_user\n"
source azuracast/user.sh &>>"${LOG_FILE}"

# setup_mariadb
echo -en "\n- 3/10 setup_mariadb\n"
source mariadb/setup.sh &>>"${LOG_FILE}"

# setup_stations
echo -en "\n- 4/10 setup_stations\n"
source stations/setup.sh &>>"${LOG_FILE}"

# setup_web
echo -en "\n- 5/10 setup_web\n"
source web/setup.sh &>>"${LOG_FILE}"

# setup_sftpgo
echo -en "\n- 6/10 setup_sftpgo\n"
source sftpgo/setup.sh &>>"${LOG_FILE}"

# setup_azuracast_install
echo -en "\n- 7/10 setup_azuracast_install\n"
source azuracast/install.sh &>>"${LOG_FILE}"

# Just check permissions again
echo -en "\n- 8/10 Set Azuracast Permissions\n"
chown -R azuracast.azuracast /var/azuracast &>>"${LOG_FILE}"

# setup_supervisor
echo -en "\n- 9/10 setup_supervisor\n"
source supervisor/setup.sh &>>"${LOG_FILE}"

# Update and Upgrade System again
echo -en "\n- 10/10 Set Azuracast Permissions\n"
source misc/finalize.sh &>>"${LOG_FILE}"
