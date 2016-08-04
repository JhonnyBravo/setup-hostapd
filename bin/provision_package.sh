#!/bin/bash

script_name=$(basename "$0")

package="hostapd iw isc-dhcp-server haveged"

i_flag=0
u_flag=0

function usage(){
cat <<_EOT_
NAME
  ${script_name}

USAGE
  ${script_name} [-i] [-u] [-h]

DESCRIPTION
  ${package} をインストール / アンインストールします。

OPTIONS
  -i  ${package} をインストールします。
  -u  ${package} をアンインストールします。
  -h  ヘルプを表示します。
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
      usage
      ;;
    \?)
      usage
      ;;
  esac
done

if [ $i_flag -eq 1 ]; then
  apt-get install $package
elif [ $u_flag -eq 1 ]; then
  apt-get purge $package
fi
