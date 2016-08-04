#!/bin/bash

package_name="isc-dhcp-server hostapd"
script_name=$(basename "$0")

e_flag=0
d_flag=0

function usage(){
cat <<_EOT_
NAME
  ${script_name}

USAGE
  ${script_name} [-e] [-d] [-h]

DESCRIPTION
  ${package_name} ufw を有効 / 無効にします。

OPTIONS
  -e  ${package_name} ufw を有効にします。

  -d  ${package_name} ufw を無効にします。

  -h  ヘルプを表示します。
_EOT_
exit 1
}

while getopts "edh" option
do
  case $option in
    e)
      e_flag=1
      ;;
    d)
      d_flag=1
      ;;
    h)
      usage
      ;;
    \?)
      usage
      ;;
  esac
done

if [ $e_flag -eq 1 ]; then
  for service_name in $package_name
  do
    service "$service_name" start
  done

  ufw enable
elif [ $d_flag -eq 1 ]; then
  for service_name in $package_name
  do
    service "$service_name" stop
  done

  ufw disable
fi
