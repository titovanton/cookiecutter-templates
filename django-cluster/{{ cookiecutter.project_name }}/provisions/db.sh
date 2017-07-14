#!/usr/bin/env bash

source /vagrant/provisions/settings.sh

# hostname
hostname {{ cookiecutter.project_name }}-db
echo "127.0.0.1 {{ cookiecutter.project_name }}-db" >> /etc/hosts
echo "{{ cookiecutter.project_name }}-db" > /etc/hostname

apt-get install -y postgresql
apt-get install -y postgresql-contrib

# pg_hba.conf
PGV=$(service postgresql status | egrep -o ^[0-9]*?\.[0-9]*?)

cp /etc/postgresql/$PGV/main/pg_hba.conf\
   /etc/postgresql/$PGV/main/pg_hba.conf.default

cat /etc/postgresql/$PGV/main/pg_hba.conf.default | grep ^[^#] >\
    /etc/postgresql/$PGV/main/pg_hba.conf

echo "hostssl all all {{ cookiecutter.django_ip }}/32 md5" >>\
     /etc/postgresql/$PGV/main/pg_hba.conf
     
chown -R postgres:postgres /etc/postgresql/$PGV/main/

# postgresql.conf
sed -e "s/#listen_addresses = 'localhost'/listen_addresses = '{{ cookiecutter.db_ip }}'/g"\
    -i /etc/postgresql/$PGV/main/postgresql.conf

service postgresql restart

# create db and role
sudo -u postgres psql -c "CREATE ROLE {{ cookiecutter.project_name }} WITH LOGIN PASSWORD '{{ cookiecutter.db_pwd }}';"
sudo -u postgres psql -c 'ALTER USER {{ cookiecutter.project_name }} CREATEDB;'
sudo -u postgres psql -c 'CREATE DATABASE {{ cookiecutter.project_name }} OWNER {{ cookiecutter.project_name }};'
sudo -u postgres psql -c 'GRANT ALL ON DATABASE {{ cookiecutter.project_name }} TO {{ cookiecutter.project_name }};'
