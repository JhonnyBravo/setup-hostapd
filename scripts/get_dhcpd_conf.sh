#!/bin/bash
template_path="/etc/dhcp/dhcpd.conf"

function usage(){
cat <<_EOT_
Usage:
  ${0} [-h]

Description:
  $template_path を現在のディレクトリへコピーします。

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

cat "$template_path" >dhcpd.conf
