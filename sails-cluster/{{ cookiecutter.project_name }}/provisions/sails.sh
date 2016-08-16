#!/usr/bin/env bash

# hostname
hostname {{ cookiecutter.project_name }}-sls
echo "127.0.0.1 {{ cookiecutter.project_name }}-sls" >> /etc/hosts
echo "{{ cookiecutter.project_name }}-sls" > /etc/hostname

# .bashrc
echo "cd {{ cookiecutter.cd_dir }}" >> /home/vagrant/.bashrc

# install sass
gem install sass

# node
apt-get autoremove -y node
apt-get install -y build-essential
apt-get install -y git
curl -sL https://deb.nodesource.com/setup_4.x | bash -
apt-get install -y nodejs

# sails
npm install -g sails
npm install -g nodemon

mkdir -p {{ cookiecutter.prj_dr }}
cd {{ cookiecutter.prj_dr }}
sails new {{ cookiecutter.project_name }}

# dependencies
npm install elasticsearch --save

chown -R {{ cookiecutter.project_owner }}:{{ cookiecutter.project_owner }} {{ cookiecutter.prj_dr }}

echo "Voila!"
