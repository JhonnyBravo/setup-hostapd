#!/bin/bash

gateway='192.168.0.1'
mask='255.255.0.0'

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

ufw disable && ufw enable
service hostapd restart
ifconfig wlan0 "$gateway" netmask "$mask"
service isc-dhcp-server restart
