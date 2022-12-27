#!/usr/bin/env bash

# Packages required by Liquidsoap
apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends libao-dev libasound2-dev libavcodec-dev libavdevice-dev libavfilter-dev libavformat-dev \
    libavutil-dev libfaad-dev libfdk-aac-dev libflac-dev libfreetype-dev libgd-dev libjack-dev \
    libjpeg-dev liblo-dev libmad0-dev libmagic-dev libmp3lame-dev libopus-dev libpng-dev libportaudio2 \
    libpulse-dev libsamplerate0-dev libsdl2-dev libsdl2-ttf-dev libsdl2-image-dev libshine-dev libsoundtouch-dev libspeex-dev \
    libsrt-openssl-dev libswresample-dev libswscale-dev libtag1-dev libtheora-dev libtiff-dev libx11-dev libxpm-dev \
    bubblewrap ffmpeg

# Optional audio plugins
apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends frei0r-plugins-dev ladspa-sdk multimedia-audio-plugins swh-plugins tap-plugins lsp-plugins-ladspa

# Per-architecture LS installs
ARCHITECTURE=$(dpkg --print-architecture)

mkdir -p bd_build/liquidsoap
cd bd_build/liquidsoap

wget -O liquidsoap.deb "https://github.com/savonet/liquidsoap/releases/download/v2.1.2/liquidsoap_2.1.2-ubuntu-jammy-1_${ARCHITECTURE}.deb"

dpkg -i liquidsoap.deb

apt-get install -o DPkg::Lock::Timeout=-1 -y -f --no-install-recommends

ln -s /usr/bin/liquidsoap /usr/local/bin/liquidsoap

cd $installerHome

### I personally using liquidsoap on hundred on systems over the last years.
### One thing that are alyways was a problem is liquidsoap when it is installed like here or over apt. (eg updates, modifications, encoder versions itself (not always actual with apt) etc...)
### I personally would prefer the OPAM variant, but this is much more work than this here.

# Install OPAM
#apt-get install -o DPkg::Lock::Timeout=-1 -y opam

# OPAM should never runs as "root" user
# Just an example with example modules for now
#su azuracast <<'EOF'
#mkdir -p /var/azuracast/liquidsoap
#cd /var/azuracast/liquidsoap
#opam init
#eval $(opam env)
##opam switch create 4.08.0
#opam install taglib mad lame vorbis cry samplerate liquidsoap fdkaac ocurl ........ -y
#eval $(opam env)
#opam update
#EOF
