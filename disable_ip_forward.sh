#!/bin/bash

# ルール初期化
iptables -F
iptables -t nat -F
iptables -X

iptables -P INPUT ACCEPT
iptables -P OUTPUT ACCEPT
iptables -P FORWARD ACCEPT

echo 0 > /proc/sys/net/ipv4/ip_forward
