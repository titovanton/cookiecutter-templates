#!/usr/bin/env bash

# hostname
hostname {{ cookiecutter.project_name }}-dj
echo "127.0.0.1 {{ cookiecutter.project_name }}-dj" >> /etc/hosts
echo "{{ cookiecutter.project_name }}-dj" > /etc/hostname

# pip
apt-get install -y python2.7-dev
apt-get install -y python-pip
pip install --upgrade pip

# uwsgi
pip install uwsgi
mkdir -p /etc/uwsgi
mkdir -p /var/log/uwsgi
cp {{ cookiecutter.cfg_dr }}/uwsgi.ini /etc/uwsgi
UWSGI_COMMAND="/usr/local/bin/uwsgi --ini /etc/uwsgi/uwsgi.ini"

if [ {{ cookiecutter.vagrant }} ]; then
  echo 'start on vagrant-mounted' > /etc/init/uwsgi.conf
  echo "exec ${UWSGI_COMMAND}" >> /etc/init/uwsgi.conf
else
  sed -e "s|^exit 0$|${UWSGI_COMMAND}\n\nexit 0|g" -i /etc/rc.local
fi

# db client
apt-get install -y postgresql-client
apt-get install -y python-psycopg2

# gettext
# apt-get install -y gettext

# Supervisor
# apt-get install -y supervisor

# Redis
# {{ cookiecutter.snc_dr }}/addons/redis.sh

# ES as search index
# {{ cookiecutter.snc_dr }}/addons/elasticsearch.sh

# node.js
# {{ cookiecutter.snc_dr }}/addons/nodejs.sh

# beautifulsoup
# {{ cookiecutter.snc_dr }}/addons/beautifulsoup.sh

# node-less
# npm install -g less

# ExifTool
# apt-get install -y libimage-exiftool-perl

# node-coffeescript
# npm install -g coffee-script

# ruby
# apt-get install -y ruby-full

# ruby-sass
# apt-get install -y ruby-sass

# GeoIP
# apt-get install -y geoip-bin

# install Django
pip install {{ cookiecutter.django_version }}

# pip requirements
pip install -U -r {{ cookiecutter.snc_dr }}/requirements.pip

# Start the project if does not exist.
# If exists, it means that we clone it from github/bitbucket,
# then creation is needless.
if [ ! -d {{ cookiecutter.prj_dr }}/app ]; then
  cd {{ cookiecutter.prj_dr }}
  django-admin.py startproject app .
  ./manage.py migrate
fi

# run uWSGI
$UWSGI_COMMAND
