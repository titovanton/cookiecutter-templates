#!/bin/bash

# Источник: http://help.ubuntu.ru/wiki/iptables

# allow related and established connections
iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# allow icmp service traffic
iptables -A INPUT -p icmp -j ACCEPT

# allow trusted traffic to the loopback
iptables -A INPUT -i lo -j ACCEPT

# remote.ssh
iptables -A INPUT -p tcp -m conntrack --ctstate NEW -m tcp --dport 22 -j ACCEPT

# ES
iptables -A INPUT -i eth1 -p tcp -m conntrack --ctstate NEW -m multiport --dports 9200 -j ACCEPT

# denny anything else
iptables -A INPUT -j REJECT --reject-with icmp-host-prohibited

# forwarding
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
iptables -A FORWARD -p icmp -j ACCEPT
iptables -A FORWARD -j REJECT --reject-with icmp-host-prohibited
