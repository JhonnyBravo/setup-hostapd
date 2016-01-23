#!/bin/bash

gateway='192.168.126.1'
mask='255.255.255.0'
range='192.168.126.0/24'

function usage(){
cat <<_EOT_
Usage:
  ${0} [-h]

Description:
  無線 LAN アクセスポイントとして機能するように
  ネットワークを設定します。

Options:
  -h ヘルプを表示します。
_EOT_
exit 1
}

while getopts "h" option
do
  case $option in
    h)
      usage
      ;;
    \?)
      usage
      ;;
  esac
done

service hostapd restart
ifconfig wlan0 "$gateway" netmask "$mask"
service isc-dhcp-server restart
sysctl -w net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -s "$range" -o eth0 -j MASQUERADE
