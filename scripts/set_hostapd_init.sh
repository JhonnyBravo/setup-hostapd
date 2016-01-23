#!/bin/bash

destination="/etc/default/hostapd"

function usage(){
cat <<_EOT_
Usage:
  ${0} path [-h]

Description:
  path に指定したファイルを ${destination} へ
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

source="$1"
install "$source" "$destination" -m 0644
