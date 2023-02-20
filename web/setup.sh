#!/usr/bin/env bash

# Source all the necessary scripts to set up the web components of AzuraCast
source web/setup/audiowaveform.sh || { echo "Error sourcing audiowaveform.sh"; exit 1; }
source web/setup/beanstalkd.sh || { echo "Error sourcing beanstalkd.sh"; exit 1; }
source web/setup/centrifugo.sh || { echo "Error sourcing centrifugo.sh"; exit 1; }
source web/setup/cron.sh || { echo "Error sourcing cron.sh"; exit 1; }
source web/setup/dbip.sh || { echo "Error sourcing dbip.sh"; exit 1; }
source web/setup/nginx.sh || { echo "Error sourcing nginx.sh"; exit 1; }
source web/setup/php.sh || { echo "Error sourcing php.sh"; exit 1; }
source web/setup/composer.sh || { echo "Error sourcing composer.sh"; exit 1; }
source web/setup/tmpreaper.sh || { echo "Error sourcing tmpreaper.sh"; exit 1; } # TODO: Check it later
source web/setup/zstd.sh || { echo "Error sourcing zstd.sh"; exit 1; }
source web/setup/npm.sh || { echo "Error sourcing npm.sh"; exit 1; }
