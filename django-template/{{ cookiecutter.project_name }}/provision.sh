#!/usr/bin/env bash

# .bashrc
echo "cd {{ cookiecutter.cd_dir }}" >> /home/{{ cookiecutter.linux_usr }}/.bashrc

# hostname
hostname {{ cookiecutter.project_name }}
echo "127.0.0.1 {{ cookiecutter.project_name }}" >> /etc/hosts
echo "{{ cookiecutter.project_name }}" > /etc/hostname

ln -s /var/log /log

apt-get update
apt-get upgrade -y
apt-get install -y htop
apt-get install -y git
apt-get install -y build-essential

adduser www-data {{ cookiecutter.linux_usr }}

# regexp like in perl
# needed for nginx and uwsgi both
apt-get install -y libpcre3
apt-get install -y libpcre3-dev


echo '#########################################################################'
echo '#                             PostgreSQL                                #'
echo '#########################################################################'

# server
apt-get install -y postgresql
apt-get install -y postgresql-contrib

# client
apt-get install -y postgresql-client
apt-get install -y python-psycopg2

PGV=$(psql --version | egrep -i postgresql | egrep -o [0-9]\.[0-9])

# django asks for those two
# server side
apt-get install -y postgresql-server-dev-$PGV

# client side
apt-get install -y libpq-dev

# pg_hba.conf

cp /etc/postgresql/$PGV/main/pg_hba.conf\
   /etc/postgresql/$PGV/main/pg_hba.conf.default

cat /etc/postgresql/$PGV/main/pg_hba.conf.default | grep ^[^#] >\
    /etc/postgresql/$PGV/main/pg_hba.conf.clean

cp {{ cookiecutter.cfg_dr }}/postgresql/pg_hba.conf /etc/postgresql/$PGV/main/
chown -R postgres:postgres /etc/postgresql/$PGV/main/
service postgresql restart

# create db and role
sudo -u postgres psql -c "CREATE ROLE {{ cookiecutter.db_usr }} WITH LOGIN PASSWORD '{{ cookiecutter.db_pwd }}';"
sudo -u postgres psql -c 'ALTER USER {{ cookiecutter.db_usr }} CREATEDB;'
sudo -u postgres psql -c 'CREATE DATABASE {{ cookiecutter.db_usr }} OWNER {{ cookiecutter.db_usr }};'
sudo -u postgres psql -c 'GRANT ALL ON DATABASE {{ cookiecutter.db_usr }} TO {{ cookiecutter.db_usr }};'


echo '#########################################################################'
echo '#                               Django                                  #'
echo '#########################################################################'

# pip
apt-get install -y python2.7-dev
apt-get install -y python-pip

# PIL asks for that
apt-get install -y libjpeg-dev

pip install --upgrade pip

# install Django
pip install {{ cookiecutter.django_version }}

# pip requirements
pip install -U -r {{ cookiecutter.snc_dr }}/requirements.pip

# Start the project if does not exist.
# If exists, it means that we clone it from github/bitbucket,
# then creation is needless.
if [ ! -d {{ cookiecutter.prj_dr }}/app ]; then
  # start project
  mkdir -p {{ cookiecutter.prj_dr }}
  cd {{ cookiecutter.prj_dr }}
  django-admin.py startproject --template {{ cookiecutter.prj_tpl }} project {{ cookiecutter.prj_dr }}

  # clone bicycle
  cd {{ cookiecutter.prj_dr }}/bicycle
  git clone https://github.com/titovanton/bicycle-core.git core

  # .gitignore
  cp {{ cookiecutter.cfg_dr }}/gitignore/project {{ cookiecutter.prj_dr }}/.gitignore
  cp {{ cookiecutter.cfg_dr }}/gitignore/settings {{ cookiecutter.prj_dr }}/app/settings/.gitignore

  # migrations
  cd {{ cookiecutter.prj_dr }}
  ./manage.py migrate
fi


echo '#########################################################################'
echo '#                               Addons                                  #'
echo '#########################################################################'

# gettext
apt-get install -y gettext

## Supervisor
# apt-get install -y supervisor
# cp {{ cookiecutter.cfg_dr }}/supervisor/rqworker.conf /etc/supervisor/conf.d/

# Redis
{{ cookiecutter.snc_dr }}/addons/redis.sh

## ES as search index
# {{ cookiecutter.snc_dr }}/addons/elasticsearch.sh

# node.js
{{ cookiecutter.snc_dr }}/addons/nodejs.sh
cd {{ cookiecutter.prj_dr }}
npm install

# ExifTool
apt-get install -y libimage-exiftool-perl

## beautifulsoup
# {{ cookiecutter.snc_dr }}/addons/beautifulsoup.sh

## ruby
# apt-get install -y ruby-full

## ruby-sass
# apt-get install -y ruby-sass

## GeoIP
# apt-get install -y geoip-bin


echo '#########################################################################'
echo '#                                uWSGI                                  #'
echo '#########################################################################'

pip install uwsgi

# config
mkdir -p /etc/uwsgi
cp {{ cookiecutter.cfg_dr }}/uwsgi.ini /etc/uwsgi

# log
mkdir -p /var/log/uwsgi
chown -R www-data:www-data /var/log/uwsgi

# systemd
cp {{ cookiecutter.cfg_dr }}/systemd/uwsgi.service /etc/systemd/system/

# run
systemctl start uwsgi

# on boot aswell
systemctl enable uwsgi


echo '#########################################################################'
echo '#                                NGINX                                  #'
echo '#########################################################################'

apt-get install -y nginx
sed -e "s/# \(server_names_hash_bucket_size 64\)/\1/g" -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_vary\)/\1/g"                        -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_proxied\)/\1/g"                     -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_comp_level\)/\1/g"                  -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_buffers\)/\1/g"                     -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_http_version\)/\1/g"                -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_types\)/\1/g"                       -i /etc/nginx/nginx.conf

# config
IP=$(ifconfig eth0 | grep "inet addr" | cut -d ':' -f 2 | cut -d ' ' -f 1)

rm /etc/nginx/sites-enabled/default

sed -e "s|%IP%|$IP|g" {{ cookiecutter.cfg_dr }}/nginx/80.conf > /etc/nginx/sites-available/80.conf
sed -e "s|%IP%|$IP|g" {{ cookiecutter.cfg_dr }}/nginx/8000.conf > /etc/nginx/sites-available/8000.conf

ln -s /etc/nginx/sites-available/80.conf /etc/nginx/sites-enabled/80.conf
ln -s /etc/nginx/sites-available/8000.conf /etc/nginx/sites-enabled/8000.conf

/etc/init.d/nginx restart
