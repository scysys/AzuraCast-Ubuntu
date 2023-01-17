#!/usr/bin/env bash

##############################################################################
# setup_azuracast_build
##############################################################################

### Build
cd /var/azuracast/www/frontend

# Simple way to switch to production
export NODE_ENV=production

# Pull Node Dependencies
npm ci

# Build AzuraCast Frontend Scripts
npm run build

cd $installerHome
