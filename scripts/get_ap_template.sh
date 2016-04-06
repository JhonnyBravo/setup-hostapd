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
  ./${template_directory} へ一括コピーします。

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

if [ ! -d "$template_directory" ]; then
  mkdir "$template_directory"
fi

provision_dnsmasq_conf.sh -g "$template_directory"
provision_hostapd_conf.sh -g "$template_directory"
provision_hostapd_init.sh -g "$template_directory"
provision_interfaces.sh -g "$template_directory"
provision_network_manager_conf.sh -g "$template_directory"
provision_rc_local.sh -g "$template_directory"
provision_sysctl_conf.sh -g "$template_directory"
