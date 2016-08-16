#!/usr/bin/env bash

# hostname
hostname {{ cookiecutter.project_name }}-ngs
echo "127.0.0.1 {{ cookiecutter.project_name }}-ngs" >> /etc/hosts
echo "{{ cookiecutter.project_name }}-ngs" > /etc/hostname

rm /etc/nginx/sites-enabled/default
cp {{ cookiecutter.cfg_dr }}/nginx_static.conf /etc/nginx/sites-available/static.conf
ln -s /etc/nginx/sites-available/static.conf /etc/nginx/sites-enabled/static.conf
/etc/init.d/nginx restart
