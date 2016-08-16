#!/usr/bin/env bash

# hostname
hostname {{ cookiecutter.project_name }}-ngp
echo "127.0.0.1 {{ cookiecutter.project_name }}-ngp" >> /etc/hosts
echo "{{ cookiecutter.project_name }}-ngp" > /etc/hostname

# nginx
apt-get install -y libpcre3 # regexp like in perl
apt-get install -y libpcre3-dev
apt-get install -y nginx
sed -e "s/# \(server_names_hash_bucket_size 64\)/\1/g" -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_vary\)/\1/g"                        -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_proxied\)/\1/g"                     -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_comp_level\)/\1/g"                  -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_buffers\)/\1/g"                     -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_http_version\)/\1/g"                -i /etc/nginx/nginx.conf
sed -e "s/# \(gzip_types\)/\1/g"                       -i /etc/nginx/nginx.conf

rm /etc/nginx/sites-enabled/default
cp {{ cookiecutter.cfg_dr }}/nginx_proxy.conf /etc/nginx/sites-available/proxy.conf
ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf
/etc/init.d/nginx restart
