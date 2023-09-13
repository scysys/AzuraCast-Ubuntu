#!/usr/bin/env bash

# Packages required by Liquidsoap and Audio Post-processing
PACKAGES=(
    libao4 libfaad2 libfdk-aac2 libgd3 liblo7 libmad0 libmagic1 libportaudio2
    libsdl2-image-2.0-0 libsdl2-ttf-2.0-0 libsoundtouch1 libxpm4
    libasound2 libavcodec58 libavdevice58 libavfilter7 libavformat58 libavutil56
    libpulse0 libsamplerate0 libswresample3 libswscale5 libtag1v5
    libsrt1.4-openssl bubblewrap ffmpeg liblilv-0-0 libjemalloc2
    ladspa-sdk
)

apt_get_with_lock update
apt_get_with_lock install -y --no-install-recommends "${PACKAGES[@]}"

# Download and install Liquidsoap
ARCHITECTURE=$(dpkg --print-architecture | awk -F- '{ print $NF }')
LIQUIDSOAP_DEB_URL="https://github.com/savonet/liquidsoap-release-assets/releases/download/rolling-release-v2.2.x/liquidsoap-b46726d_2.2.1-ubuntu-jammy-1_${ARCHITECTURE}.deb"
wget -O liquidsoap.deb "$LIQUIDSOAP_DEB_URL"
dpkg -i liquidsoap.deb

# Install any missing dependencies
apt_get_with_lock install -y -f --no-install-recommends

# Create a symbolic link for liquidsoap
ln -s /usr/bin/liquidsoap /usr/local/bin/liquidsoap

# Clean up
rm -f liquidsoap.deb

# Go back to the installer home directory
cd "$installerHome"
