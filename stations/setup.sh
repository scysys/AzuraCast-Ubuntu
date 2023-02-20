#!/usr/bin/env bash

# Source all the necessary scripts to set up the station components of AzuraCast
source stations/setup/flac.sh || { echo "Error sourcing flac.sh"; exit 1; }
source stations/setup/icecast.sh || { echo "Error sourcing icecast.sh"; exit 1; }
source stations/setup/liquidsoap.sh || { echo "Error sourcing liquidsoap.sh"; exit 1; }
source stations/setup/vorbis.sh || { echo "Error sourcing vorbis.sh"; exit 1; }
