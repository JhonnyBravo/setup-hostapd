#!/bin/bash

out_dir="template"
hostapd_init="/etc/default/hostapd"
dhcpd_init="/etc/default/isc-dhcp-server"
interfaces_init="/etc/network/interfaces"
ufw_init="/etc/default/ufw"
init_list="${hostapd_init} ${dhcpd_init} ${interfaces_init} ${ufw_init}"

function usage(){
cat <<_EOT_
Usage:
  ${0} [-h]

Description:
  ${hostapd_init},
  ${dhcpd_init},
  ${interfaces_init},
  ${ufw_init} を
  ./${out_dir} へコピーします。

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

if [ ! -d "$out_dir" ]; then
  mkdir "$out_dir"
fi

for init_path in $init_list
do
  out_file=$(basename "$init_path")
  cat "$init_path" >"${out_dir}/${out_file}"
done
