#!/bin/bash

package="hostapd iw isc-dhcp-server haveged"

i_flag=0
u_flag=0
h_flag=0

i_description="-i ${package} をインストールします。"
u_description="-u ${package} をアンインストールします。"
h_description="-h ヘルプを表示します。"

function get_usage(){
  cat <<_EOT_
Usage:
  ${0} [-i] [-u] [-h]

Description:
  ${package} を
  インストール / アンインストールします。

Options:
  ${i_description}
  ${u_description}
  ${h_description}
_EOT_

exit 1
}

while getopts "iuh" option
do
  case $option in
    i)
      i_flag=1
      ;;
    u)
      u_flag=1
      ;;
    h)
      h_flag=1
      ;;
    \?)
      h_flag=1
      ;;
  esac
done

if [ $i_flag -eq 1 ]; then
  # shellcheck disable=SC2086
  apt-get install $package
elif [ $u_flag -eq 1 ]; then
  # shellcheck disable=SC2086
  apt-get purge $package
elif [ $h_flag -eq 1 ]; then
  get_usage
fi
