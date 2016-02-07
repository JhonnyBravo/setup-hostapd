#!/bin/bash

function usage(){
cat <<_EOT_
Usage:
  ${0} [-h]

Description:
  hostapd, isc-dhcp-server を停止します。

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

service hostapd stop
service isc-dhcp-server stop
