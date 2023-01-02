#!/usr/bin/env bash

##############################################################################
# setup_web
##############################################################################

source web/setup/audiowaveform.sh
source web/setup/beanstalkd.sh
source web/setup/centrifugo.sh
source web/setup/cron.sh
source web/setup/dbip.sh
source web/setup/nginx.sh
source web/setup/php.sh
source web/setup/composer.sh
source web/setup/tmpreaper.sh # TODO: must check this. removed variables in bad way :p
source web/setup/zstd.sh
source web/setup/npm.sh
