#!/usr/bin/env bash

apt-get autoremove -y node
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs
