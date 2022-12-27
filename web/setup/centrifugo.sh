#!/usr/bin/env bash

apt-get install -o DPkg::Lock::Timeout=-1 -y --no-install-recommends golang

go install github.com/centrifugal/centrifugo/v4@d465b5932ab786273f081392e1dc8fdfd2d2ec10

mv /root/go/bin/centrifugo /usr/local/bin/centrifugo
rm -rf /root/go

cp web/centrifugo/config.json /var/azuracast/centrifugo/config.json
