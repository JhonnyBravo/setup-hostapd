#!/bin/bash

in_router='192.168.2.1'
in_ip_address='192.168.2.0/24'

ex_router='192.168.1.1'
ex_ip_address='192.168.1.0/24'

echo 1 > /proc/sys/net/ipv4/ip_forward

# ルール初期化
iptables -F
iptables -t nat -F
iptables -X

iptables -P INPUT DROP
iptables -P OUTPUT ACCEPT
iptables -P FORWARD DROP

iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -A FORWARD -i eth0 -o wlan0 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i wlan0 -o eth0 -s $in_ip_address -j ACCEPT

# lo
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# ICMP in_ip_address -> in_router
iptables -A INPUT -p icmp --icmp-type echo-request -s $in_ip_address -d $in_router -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -s $in_router -d $in_ip_address -j ACCEPT

# ICMP in_router -> in_ip_address
iptables -A OUTPUT -p icmp --icmp-type echo-request -s $in_router -d $in_ip_address -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -s $in_ip_address -d $in_router -j ACCEPT

# NTP
iptables -A OUTPUT -o eth0 -s $ex_ip_address -p udp --sport 123 --dport 123 -j ACCEPT
iptables -A OUTPUT -o eth0 -s $in_router -p udp --sport 123 --dport 123 -j ACCEPT

# DNS
iptables -A OUTPUT -o eth0 -s $ex_ip_address -d $ex_router -p udp --sport 32768:60999 --dport 53 -j ACCEPT

# DHCP
iptables -A OUTPUT -o wlan0 -s $in_router -d $in_ip_address -p udp --sport 67 --dport 68 -j ACCEPT
iptables -A INPUT -i wlan0 -s $in_ip_address -d $in_router -p udp --sport 68 --dport 67 -j ACCEPT

iptables -A OUTPUT -o eth0 -s $ex_ip_address -d $ex_router -p udp --sport 68 --dport 67 -j ACCEPT
iptables -A INPUT -i eth0 -s $ex_router -d $ex_ip_address -p udp --sport 67 --dport 68 -j ACCEPT

iptables -A INPUT -i eth0 -s $ex_router -d 255.255.255.255 -p udp --sport 67 --dport 68 -j ACCEPT
iptables -A INPUT -i eth0 -d 255.255.255.255 -p udp --sport 68 --dport 67 -j ACCEPT
iptables -A INPUT -i wlan0 -d 255.255.255.255 -p udp --sport 68 --dport 67 -j ACCEPT

# mDNS
iptables -A OUTPUT -o eth0 -s $ex_ip_address -d 224.0.0.251 -p udp --sport 5353 --dport 5353 -j ACCEPT
iptables -A INPUT -i eth0 -s $ex_ip_address -d 224.0.0.251 -p udp --sport 5353 --dport 5353 -j ACCEPT

iptables -A OUTPUT -o wlan0 -s $in_router -d 224.0.0.251 -p udp --sport 5353 --dport 5353 -j ACCEPT
iptables -A INPUT -i wlan0 -s $in_ip_address -d 224.0.0.251 -p udp --sport 5353 --dport 5353 -j ACCEPT

# Apple プッシュ通知サービス
iptables -A OUTPUT -o eth0 -s $ex_ip_address -p tcp --sport 49152:65535 --dport 5223 -j ACCEPT
iptables -A INPUT -i eth0 -d $ex_ip_address -p tcp --sport 5223 --dport 49152:65535 -j ACCEPT

# HTTPS
iptables -A INPUT -i eth0 -d $ex_ip_address -p tcp --sport 443 --dport 32768:65535 -j ACCEPT

# HTTP
iptables -A INPUT -i eth0 -d $ex_ip_address -p tcp --sport 80 --dport 32768:65535 -j ACCEPT

# netbios-ns
iptables -A INPUT -i eth0 -s $ex_ip_address -d 192.168.1.255 -p udp --sport 137 --dport 137 -j ACCEPT
iptables -A INPUT -i wlan0 -s $in_ip_address -d 192.168.2.255 -p udp --sport 137 --dport 137 -j ACCEPT

# netbios-dgm
iptables -A INPUT -i eth0 -s $ex_ip_address -d 192.168.1.255 -p udp --sport 138 --dport 138 -j ACCEPT
iptables -A INPUT -i wlan0 -s $in_ip_address -d 192.168.2.255 -p udp --sport 138 --dport 138 -j ACCEPT

# discard
iptables -A INPUT -i wlan0 -s $in_ip_address -d 224.0.0.251 -p udp --sport 49152:65535 --dport 9 -j ACCEPT

# igmp.mcast.net
iptables -A OUTPUT -o eth0 -s $ex_ip_address -d 224.0.0.22 -j ACCEPT
iptables -A OUTPUT -o wlan0 -s $in_router -d 224.0.0.22 -j ACCEPT

iptables -A OUTPUT -o wlan0 -s $in_router -d $in_ip_address -j ACCEPT
iptables -A OUTPUT -o eth0 -s $ex_ip_address -j ACCEPT

# nat
iptables -t nat -A POSTROUTING -o eth0 -s $in_ip_address -j MASQUERADE

# private address
iptables -A OUTPUT -o eth0 -d 10.0.0.0/8 -j DROP
iptables -A OUTPUT -o eth0 -d 176.16.0.0/12 -j DROP
iptables -A OUTPUT -o eth0 -d 127.0.0.0/8 -j DROP

# log
iptables -N LOGGING
iptables -A LOGGING -j LOG --log-level warning --log-prefix "DROP:" -m limit
iptables -A LOGGING -j DROP

iptables -A INPUT -j LOGGING
iptables -A OUTPUT -j LOGGING
iptables -A FORWARD -j LOGGING
