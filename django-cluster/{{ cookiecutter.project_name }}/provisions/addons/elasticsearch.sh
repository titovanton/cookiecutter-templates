#!/usr/bin/env bash

apt-get install -y openjdk-7-jre-headless
cd /usr/src
wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-1.1.1.deb
dpkg -i elasticsearch-1.1.1.deb
/usr/share/elasticsearch/bin/plugin \
  -install analysis-morphology \
  -url http://dl.bintray.com/content/imotov/elasticsearch-plugins/org/elasticsearch/elasticsearch-analysis-morphology/1.2.0/elasticsearch-analysis-morphology-1.2.0.zip
update-rc.d elasticsearch defaults 95 10
sed -e "s/^# network\.host: .*$/network.host: 127.0.0.1/g" -i /etc/elasticsearch/elasticsearch.yml
/etc/init.d/elasticsearch start
rm elasticsearch-1.1.1.deb
