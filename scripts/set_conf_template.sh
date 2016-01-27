#!/bin/bash

src_dir="template"
hostapd_conf="/etc/hostapd/hostapd.conf"
dhcpd_conf="/etc/dhcp/dhcpd.conf"
nw_man_conf="/etc/NetworkManager/NetworkManager.conf"
sysctl_conf="/etc/ufw/sysctl.conf"
conf_list="${hostapd_conf} ${dhcpd_conf} ${nw_man_conf} ${sysctl_conf}"

function usage(){
cat <<_EOT_
Usage:
  ${0} [-h]

Description:
  ${hostapd_conf},
  ${dhcpd_conf},
  ${nw_man_conf},
  ${sysctl_conf} を
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

for conf_path in $conf_list
do
  src_file=$(basename "$conf_path")
  install "${src_dir}/${src_file}" "$conf_path" -m 0644
done
