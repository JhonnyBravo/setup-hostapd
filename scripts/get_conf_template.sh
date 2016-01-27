#!/bin/bash

out_dir="template"
hostapd_conf="/etc/hostapd/hostapd.conf"
dhcpd_conf="/etc/dhcp/dhcpd.conf"
nw_man_conf="/etc/NetworkManager/NetworkManager.conf"
sysctl_conf="/etc/ufw/sysctl.conf"
conf_list="${dhcpd_conf} ${nw_man_conf} ${sysctl_conf}"

function usage(){
cat <<_EOT_
Usage:
  ${0} [-h]

Description:
  ${hostapd_conf},
  ${dhcpd_conf},
  ${nw_man_conf},
  ${sysctl_conf} を
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

out_file=$(basename "$hostapd_conf")

if [ -f "$hostapd_conf" ]; then
  cat "$hostapd_conf" >"${out_dir}/${out_file}"
else
  hostapd_conf="/usr/share/doc/hostapd/examples/hostapd.conf.gz"
  zcat "$hostapd_conf" >"${out_dir}/${out_file}"
fi

for conf_path in $conf_list
do
  out_file=$(basename "$conf_path")
  cat "$conf_path" >"${out_dir}/${out_file}"
done
