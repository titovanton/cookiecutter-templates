#!/usr/bin/env bash

apt-get update
apt-get -y upgrade
apt-get install -y git
apt-get install -y htop
apt-get install -y g++
apt-get install -y build-essential

# hostname
hostname {{project_name}}
echo "127.0.0.1 {{project_name}}" >> /etc/hosts
echo "{{project_name}}" > /etc/hostname

# .bashrc
echo "cd /vagrant/project" >> /home/vagrant/.bashrc

# node
apt-get autoremove -y node
curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash -
apt-get install -y nodejs

# meteor
curl https://install.meteor.com/ | sh

# MongoDB
apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927
echo "deb http://repo.mongodb.com/apt/ubuntu trusty/mongodb-enterprise/stable multiverse" | tee /etc/apt/sources.list.d/mongodb-enterprise.list
apt-get update
apt-get install -y mongodb-enterprise

# Mongo URL
command="export MONGO_URL='mongodb://localhost:27017/{{project_name}}'"
echo $command >> /home/vagrant/.bashrc
