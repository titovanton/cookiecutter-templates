#!/usr/bin/env bash

# .bashrc
echo "cd {{ cookiecutter.cd_dir }}" >> /home/{{ cookiecutter.linux_usr }}/.bashrc

apt-get update
# apt-get upgrade -y
apt-get install -y htop
apt-get install -y build-essential

ln -s /var/log /log

adduser www-data {{ cookiecutter.linux_usr }}
