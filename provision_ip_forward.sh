#!/bin/bash

script_name=$(basename "$0")
s_flag=0
r_flag=0

function usage(){
cat <<_EOT_
NAME
  ${script_name}

USAGE
  ${script_name} [-s] [-r] [-h]

DESCRIPTION
  iptables のルール設定または設定済みルールの解除を実行します。

OPTIONS
  -s  iptables のルールを設定します。
  -r  iptables の設定済みルールを解除します。
  -h  ヘルプを表示します。
_EOT_
exit 1
}

# ssh_client= # ssh 接続を許可する端末の ip アドレス
# ssh_port= # ssh 接続に使用するポート番号

ex_address='192.168.1.0/24'

ex_gateway_address=$(route -n \
  | awk '{print $2}' \
  | grep 192)

ex_inet_address=$(ifconfig eth0 \
  | awk '/inetアドレス/ {print $1}' \
  | cut -d : -f 2)

in_address='192.168.2.0/24'

in_inet_address=$(ifconfig wlan0 \
  | awk '/inetアドレス/ {print $1}' \
  | cut -d : -f 2)

function remove_rules(){
  iptables -F
  iptables -t nat -F
  iptables -X

  iptables -P INPUT ACCEPT
  iptables -P OUTPUT ACCEPT
  iptables -P FORWARD ACCEPT

  echo 0 > /proc/sys/net/ipv4/ip_forward
}

function set_policy(){
  iptables -P INPUT DROP
  iptables -P OUTPUT ACCEPT
  iptables -P FORWARD DROP
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

  echo 1 > /proc/sys/net/ipv4/ip_forward

  iptables -A FORWARD -i eth0 -o wlan0 \
    -m state --state ESTABLISHED,RELATED -j ACCEPT
  iptables -A FORWARD -i wlan0 -o eth0 \
    -s "$in_address" -j ACCEPT
}

function set_nat(){
  iptables -t nat -A POSTROUTING -o eth0 -s "$in_address" -j MASQUERADE
}

function allow_lo(){
  iptables -A INPUT -i lo -j ACCEPT
  iptables -A OUTPUT -o lo -j ACCEPT
}

function allow_ntp(){
  iptables -A OUTPUT -o eth0 -s "$in_inet_address" \
    -p udp --sport 123 --dport 123 -j ACCEPT
  iptables -A OUTPUT -o eth0 -s "$ex_inet_address" \
    -p udp --sport 123 --dport 123 -j ACCEPT
}

function allow_dhcp(){
  iptables -A INPUT -i wlan0 -s "$in_address" -d "$in_inet_address" \
    -p udp --sport 68 --dport 67 -j ACCEPT
  iptables -A OUTPUT -o wlan0 -s "$in_inet_address" -d "$in_address" \
    -p udp --sport 67 --dport 68 -j ACCEPT

  iptables -A OUTPUT -o eth0 -s "$ex_inet_address" -d "$ex_gateway_address" \
    -p udp --sport 68 --dport 67 -j ACCEPT

  iptables -A INPUT -i wlan0 -s 0.0.0.0 -d 255.255.255.255 \
    -p udp --sport 68 --dport 67 -j ACCEPT
  iptables -A INPUT -i wlan0 -s "$in_address" -d 255.255.255.255 \
    -p udp --sport 68 --dport 67 -j ACCEPT

  iptables -A INPUT -i eth0 -s 0.0.0.0 -d 255.255.255.255 \
    -p udp --sport 68 --dport 67 -j ACCEPT
  iptables -A INPUT -i eth0 -s "$ex_address" -d 255.255.255.255 \
    -p udp --sport 68 --dport 67 -j ACCEPT
}

function allow_https(){
  iptables -A OUTPUT -o eth0 -s "$ex_inet_address" \
    -p tcp --sport 32768:60999 --dport 443 -j ACCEPT
  iptables -A INPUT -i eth0 -d "$ex_inet_address" \
    -p tcp --sport 443 --dport 32768:60999 -j ACCEPT
}

function allow_http(){
  iptables -A OUTPUT -o eth0 -s "$ex_inet_address" \
    -p tcp --sport 32768:60999 --dport 80 -j ACCEPT
  iptables -A INPUT -i eth0 -d "$ex_inet_address" \
    -p tcp --sport 80 --dport 32768:60999 -j ACCEPT

  iptables -A OUTPUT -o wlan0 -s "$in_inet_address" -d "$in_address" \
    -p tcp --sport 80 --dport 32768:60999 -j ACCEPT
  iptables -A INPUT -i wlan0 -s "$in_address" -d "$in_inet_address" \
    -p tcp --sport 32768:60999 --dport 80 -j ACCEPT
}

function allow_dns(){
  iptables -A OUTPUT -o eth0 -s "$ex_inet_address" -d "$ex_gateway_address" \
    -p udp --sport 32768:60999 --dport 53 -j ACCEPT
}

function allow_mdns(){
  iptables -A OUTPUT -o wlan0 -s "$in_inet_address" -d 224.0.0.251 \
    -p udp --sport 5353 --dport 5353 -j ACCEPT
  iptables -A INPUT -i wlan0 -s "$in_address" -d 224.0.0.251 \
    -p udp --sport 5353 --dport 5353 -j ACCEPT

  iptables -A INPUT -i eth0 -s "$ex_address" -d 224.0.0.251 \
    -p udp --sport 5353 --dport 5353 -j ACCEPT

  iptables -A OUTPUT -o wlan0 -s "$in_inet_address" -d 224.0.0.22 -j ACCEPT
}

function allow_icmp(){
  # in_address -> in_inet_address
  iptables -A INPUT -s "$in_address" -d "$in_inet_address" \
    -p icmp --icmp-type echo-request -j ACCEPT
  iptables -A OUTPUT -s "$in_inet_address" -d "$in_address" \
    -p icmp --icmp-type echo-reply -j ACCEPT

  # in_inet_address -> in_address
  iptables -A OUTPUT -s "$in_inet_address" -d "$in_address" \
    -p icmp --icmp-type echo-request -j ACCEPT
  iptables -A INPUT -s "$in_address" -d "$in_inet_address" \
    -p icmp --icmp-type echo-reply -j ACCEPT
}

function allow_ssh(){
  iptables -A OUTPUT -o wlan0 -s "$in_inet_address" -d "$ssh_client" \
    -p tcp --sport "$ssh_port" -j ACCEPT
  iptables -A INPUT -i wlan0 -s "$ssh_client" -d "$in_inet_address" \
    -p tcp --dport "$ssh_port" -j ACCEPT
}

function allow_netbios_dgm(){
  iptables -A INPUT -i eth0 -s "$ex_address" -d 192.168.1.255 \
    -p udp --sport 138 --dport 138 -j ACCEPT

  iptables -A INPUT -i wlan0 -s "$in_address" -d 192.168.2.255 \
    -p udp --sport 138 --dport 138 -j ACCEPT
}

function allow_netbios_ns(){
  iptables -A INPUT -i wlan0 -s "$in_address" -d 192.168.2.255 \
    -p udp --sport 137 --dport 137 -j ACCEPT
}

function allow_discard(){
  iptables -A INPUT -i wlan0 -s "$in_address" -d 224.0.0.251 \
    -p udp --sport 49152:65535 --dport 9 -j ACCEPT
}

function set_log(){
  iptables -N LOGGING
  iptables -A LOGGING -j LOG --log-level warning --log-prefix "DROP:" -m limit
  iptables -A LOGGING -j DROP

  iptables -A INPUT -j LOGGING
  iptables -A OUTPUT -j LOGGING
}

while getopts "srh" option
do
  case $option in
    s)
      s_flag=1
      ;;
    r)
      r_flag=1
      ;;
    h)
      usage
      ;;
    \?)
      usage
      ;;
  esac
done

if [ $r_flag -eq 1 ]; then
  remove_rules
elif [ $s_flag -eq 1 ]; then
  remove_rules
  set_policy
  set_nat
  allow_lo
  allow_icmp
  allow_dns
  allow_dhcp
  allow_https
  allow_http
  allow_ntp
  # allow_ssh
  allow_mdns
  allow_netbios_dgm
  allow_netbios_ns
  allow_discard
  set_log
fi
