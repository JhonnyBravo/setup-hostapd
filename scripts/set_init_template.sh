#!/bin/bash

src_dir="template"
hostapd_init="/etc/default/hostapd"
dhcpd_init="/etc/default/isc-dhcp-server"
ufw_init="/etc/default/ufw"
init_list="${hostapd_init} ${dhcpd_init} ${ufw_init}"

function usage(){
cat <<_EOT_
Usage:
  ${0} [-h]

Description:
  ${hostapd_init},
  ${dhcpd_init},
  ${ufw_init} を
  インストールします。

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

for init_path in $init_list
do
  src_file=$(basename "$init_path")
  install "${src_dir}/${src_file}" "$init_path" -m 0644
done
