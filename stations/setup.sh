#!/usr/bin/env bash

# Source all the necessary scripts to set up the station components of AzuraCast
source stations/setup/getid3.sh || { echo "Error sourcing getid3.sh"; exit 1; }
source stations/setup/icecast.sh || { echo "Error sourcing icecast.sh"; exit 1; }
source stations/setup/liquidsoap.sh || { echo "Error sourcing liquidsoap.sh"; exit 1; }
source stations/setup/master_me.sh || { echo "Error sourcing master_me.sh"; exit 1; }

# Return to the installer home directory
cd $installerHome
