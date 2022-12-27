#!/usr/bin/env bash

##############################################################################
# setup_azuracast_build
##############################################################################

### Build
cd /var/azuracast/www/frontend

# Pull Node Dependencies
npm ci

# Build AzuraCast Frontend Scripts
npm run build

cd $installerHome
