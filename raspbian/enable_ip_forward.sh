#!/bin/bash

internal_ip='192.168.2.0/24'
router_ip='192.168.2.1'

echo 1 > /proc/sys/net/ipv4/ip_forward

# ルール初期化
iptables -F
iptables -t nat -F
iptables -X

iptables -P INPUT DROP
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

iptables -P OUTPUT ACCEPT

iptables -P FORWARD DROP
iptables -A FORWARD -i wlan0 -o eth0 -s $internal_ip -j ACCEPT
iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT

# lo
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

# ICMP internal_ip -> router_ip
iptables -A INPUT -p icmp --icmp-type echo-request -s $internal_ip -d $router_ip -j ACCEPT
iptables -A OUTPUT -p icmp --icmp-type echo-reply -s $router_ip -d $internal_ip -j ACCEPT

# ICMP router_ip -> internal_ip
iptables -A OUTPUT -p icmp --icmp-type echo-request -s $router_ip -d $internal_ip -j ACCEPT
iptables -A INPUT -p icmp --icmp-type echo-reply -s $internal_ip -d $router_ip -j ACCEPT

# iTunes
iptables -A INPUT -p udp --sport 68 --dport 67 -j ACCEPT # bootpc, bootps
iptables -A INPUT -p udp --sport 137 --dport 137 -j ACCEPT # netbios-ns
iptables -A INPUT -p udp --sport 138 --dport 138 -j ACCEPT # netbios-dgm
iptables -A INPUT -p udp --sport 5353 --dport 5353 -j ACCEPT # mdns

# nat
iptables -t nat -A POSTROUTING -o eth0 -s $internal_ip -j MASQUERADE

# プライベートアドレス
iptables -A OUTPUT -o eth0 -d 10.0.0.0/8 -j DROP
iptables -A OUTPUT -o eth0 -d 176.16.0.0/12 -j DROP
iptables -A OUTPUT -o eth0 -d 127.0.0.0/8 -j DROP

# log
iptables -N LOGGING
iptables -A LOGGING -j LOG --log-level warning --log-prefix "DROP:" -m limit
iptables -A LOGGING -j DROP

iptables -A INPUT -j LOGGING
iptables -A FORWARD -j LOGGING
