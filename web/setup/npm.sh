#!/usr/bin/env bash

curl -L https://raw.githubusercontent.com/tj/n/master/bin/n -o npm_install && bash npm_install lts
rm -f npm_install
