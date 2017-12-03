#!/bin/bash

# internal network
myhost=$(ifconfig wlan0 \
  | awk 'NR==2 {print $1}' \
  | cut -d : -f 2)

trusthost="${myhost:0:10}0/24"

# ssh
# ssh_trusthost=''
# ssh_port=''

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

function remove_rules(){
  echo 0 > /proc/sys/net/ipv4/ip_forward

  iptables -F
  iptables -Z
  iptables -X

  iptables -t nat -F
  iptables -t nat -Z
  iptables -t nat -X

  iptables -P INPUT ACCEPT
  iptables -P OUTPUT ACCEPT
  iptables -P FORWARD ACCEPT
}

function set_policy(){
  echo 1 > /proc/sys/net/ipv4/ip_forward

  iptables -P INPUT DROP
  iptables -P OUTPUT ACCEPT
  iptables -P FORWARD DROP
  iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
}

function set_forward(){
  iptables -A FORWARD -i wlan0 -o eth0 -s "$trusthost" -j ACCEPT
  iptables -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
}

function set_nat(){
  iptables -t nat -A POSTROUTING -o eth0 -s "$trusthost" -j MASQUERADE
}

function set_rule_lo(){
  iptables -A INPUT -i lo -j ACCEPT
}

function set_rule_icmp(){
  # trusthost -> myhost
  iptables -A INPUT -s "$trusthost" -d "$myhost" \
    -p icmp --icmp-type echo-request -j ACCEPT

  # myhost -> trusthost
  iptables -A INPUT -s "$trusthost" -d "$myhost" \
    -p icmp --icmp-type echo-reply -j ACCEPT
}

function set_rule_ssh(){
  iptables -A INPUT -p tcp --syn -m state --state NEW \
    -s "$ssh_trusthost" -d "$myhost" --dport "$ssh_port" -j ACCEPT
}

function set_log(){
  iptables -N LOGGING
  iptables -A LOGGING -j LOG --log-level warning --log-prefix "DROP:" -m limit
  iptables -A LOGGING -j DROP

  iptables -A INPUT -j LOGGING
  iptables -A FORWARD -j LOGGING
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
  set_rule_lo
  set_rule_icmp
  # set_rule_ssh
  set_nat
  set_forward
  set_log
fi
