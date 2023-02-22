#!/usr/bin/env bash

# Install packages required by Liquidsoap and optional audio plugins
apt-get update
apt-get install -y --no-install-recommends \
  libao-dev libasound2-dev libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev \
  libavutil-dev libfaad-dev libfdk-aac-dev libflac-dev libfreetype-dev libgd-dev libjack-dev \
  libjpeg-dev liblo-dev libmad0-dev libmagic-dev libmp3lame-dev libopus-dev libpng-dev \
  libportaudio2 libpulse-dev libsamplerate0-dev libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev \
  libshine-dev libsoundtouch-dev libspeex-dev libsrt-openssl-dev libswresample-dev \
  libswscale-dev libtag1-dev libtheora-dev libtiff-dev libx11-dev libxpm-dev bubblewrap ffmpeg \
  frei0r-plugins-dev ladspa-sdk multimedia-audio-plugins swh-plugins tap-plugins lsp-plugins-ladspa

# Download and install Liquidsoap
ARCHITECTURE=$(dpkg --print-architecture)
wget -O liquidsoap.deb "https://github.com/savonet/liquidsoap/releases/download/v2.1.2/liquidsoap_2.1.2-ubuntu-jammy-1_${ARCHITECTURE}.deb"
dpkg -i liquidsoap.deb

# Install any missing dependencies
apt-get install -y -f --no-install-recommends

# Create a symbolic link for liquidsoap
ln -s /usr/bin/liquidsoap /usr/local/bin/liquidsoap

# Clean up
rm -f liquidsoap.deb

# Go back to the installer home directory
cd $installerHome
