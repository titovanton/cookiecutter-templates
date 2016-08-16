#!/usr/bin/env bash

cd /usr/src
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make
# make test
make install
mkdir -p /etc/redis
mkdir -p /var/redis/6379
cp utils/redis_init_script /etc/init.d/redis_6379
cp redis.conf /etc/redis/6379.conf
sed -e "s|daemonize no|daemonize yes|" \
    -i /etc/redis/6379.conf
sed -e "s|pidfile /var/run/redis\.pid|pidfile /run/redis_6379.pid|" \
    -i /etc/redis/6379.conf
sed -e "s|logfile \"\"|logfile \"/var/log/redis_6379.log\"|" \
    -i /etc/redis/6379.conf
sed -e "s|dir \./|dir /var/redis/6379|" \
    -i /etc/redis/6379.conf
update-rc.d redis_6379 defaults
/etc/init.d/redis_6379 start
