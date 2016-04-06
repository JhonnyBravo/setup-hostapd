#!/bin/bash

template_directory="template"

h_flag=0
h_description="-h ヘルプを表示します。"

function get_usage(){
  cat <<_EOT_
Usage:
  ${0} [-h]

Description:
  アクセスポイントの設定に使用するファイルを
  ./${template_directory} から一括インストールします。

Options:
  ${h_description}
_EOT_

exit 1
}

while getopts "h" option
do
  case $option in
    h)
      h_flag=1
      ;;
    \?)
      h_flag=1
      ;;
  esac
done

if [ $h_flag -eq 1 ]; then
  get_usage
fi

provision_dnsmasq_conf.sh -s "${template_directory}/dnsmasq.conf"
provision_hostapd_conf.sh -s "${template_directory}/hostapd.conf"
provision_hostapd_init.sh -s "${template_directory}/hostapd"
provision_interfaces.sh -s "${template_directory}/interfaces"
provision_network_manager_conf.sh -s "${template_directory}/NetworkManager.conf"
provision_rc_local.sh -s "${template_directory}/rc.local"
provision_sysctl_conf.sh -s "${template_directory}/sysctl.conf"
