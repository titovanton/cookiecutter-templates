#!/usr/bin/env bash

# hostname
hostname {{ cookiecutter.project_name }}-ngp
echo "127.0.0.1 {{ cookiecutter.project_name }}-ngp" >> /etc/hosts
echo "{{ cookiecutter.project_name }}-ngp" > /etc/hostname

rm /etc/nginx/sites-enabled/default
cp {{ cookiecutter.cfg_dr }}/nginx_proxy.conf /etc/nginx/sites-available/proxy.conf
ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf
/etc/init.d/nginx restart
