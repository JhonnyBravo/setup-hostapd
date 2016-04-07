#!/bin/bash

h_description="-h ヘルプを表示します。"

function get_usage(){
  cat <<_EOT_
Usage:
  ${0} [-h]

Description:
  hostapd, dnsmasq を起動します。

Options:
  ${h_description}
_EOT_

exit 1
}

while getopts "h" option
do
  case $option in
    h)
      get_usage
      ;;
    \?)
      get_usage
      ;;
  esac
done

service isc-dhcp-server start
service hostapd start
ufw enable
