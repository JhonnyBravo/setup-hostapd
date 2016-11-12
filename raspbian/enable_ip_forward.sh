#!/bin/bash

ex_router='192.168.1.1'
ex_ip_address='192.168.1.6'
in_router='192.168.2.1'
in_ip_address='192.168.2.0/24'

echo 1 > /proc/sys/net/ipv4/ip_forward

# ルール初期化
iptables -F
iptables -t nat -F
iptables -X

iptables -P INPUT DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -P OUTPUT ACCEPT

iptables -P FORWARD DROP
iptables -A FORWARD -i wlan0 -o eth0 -s $in_ip_address -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# lo
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# ICMP in_ip_address -> in_router
iptables -A INPUT -p icmp --icmp-type echo-request -s $in_ip_address -d $in_router -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -s $in_router -d $in_ip_address -j ACCEPT

# ICMP in_router -> in_ip_address
iptables -A OUTPUT -p icmp --icmp-type echo-request -s $in_router -d $in_ip_address -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -s $in_ip_address -d $in_router -j ACCEPT

# iTunes
# UDP
iptables -A INPUT -p udp --sport 137 --dport 137 -j ACCEPT # netbios-ns
iptables -A INPUT -p udp --sport 138 --dport 138 -j ACCEPT # netbios-dgm
iptables -A INPUT -p udp --sport 49152:65535 --dport 9 -j ACCEPT # どこでも My Mac -> discard

# TCP
iptables -A INPUT -p tcp --sport 5223 --dport 49152:65535 -j ACCEPT # Apple プッシュ通知サービス -> Xsan

# raspbian
# DNS
iptables -A OUTPUT -p udp -s $ex_ip_address --sport 32768:60999 -d $ex_router --dport 53 -j ACCEPT

# NTP
iptables -A OUTPUT -p udp -s $ex_ip_address --sport 123 --dport 123 -j ACCEPT

# HTTPS
iptables -A INPUT -p tcp --sport 443 -d $ex_ip_address --dport 32768:60999 -j ACCEPT
iptables -A OUTPUT -p tcp -s $ex_ip_address --sport 32768:60999 --dport 443 -j ACCEPT

# HTTP
iptables -A INPUT -p tcp --sport 80 -d $ex_ip_address --dport 32768:60999 -j ACCEPT
iptables -A OUTPUT -p tcp -s $ex_ip_address --sport 32768:60999 --dport 80 -j ACCEPT

# mDNS
# internal
iptables -A INPUT -p udp -s $in_ip_address --sport 5353 --dport 5353 -j ACCEPT
iptables -A OUTPUT -p udp -s $in_router --sport 5353 --dport 5353 -j ACCEPT

# external
iptables -A INPUT -p udp -s $ex_ip_address --sport 5353 --dport 5353 -j ACCEPT
iptables -A OUTPUT -p udp -s $ex_ip_address --sport 5353 --dport 5353 -j ACCEPT

# DHCP
# internal
iptables -A INPUT -p udp -s $in_ip_address --sport 68 -d $in_router --dport 67 -j ACCEPT
iptables -A OUTPUT -p udp -s $in_router --sport 67 -d $in_ip_address --dport 68 -j ACCEPT

# external
iptables -A INPUT -p udp -s $ex_router --sport 67 -d $ex_ip_address --dport 68 -j ACCEPT
iptables -A OUTPUT -p udp -s $ex_ip_address --sport 68 -d $ex_router --dport 67 -j ACCEPT

# nat
iptables -t nat -A POSTROUTING -o eth0 -s $in_ip_address -j MASQUERADE

# プライベートアドレス
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
