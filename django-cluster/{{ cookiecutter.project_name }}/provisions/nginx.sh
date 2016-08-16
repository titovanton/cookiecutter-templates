#!/usr/bin/env bash

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
