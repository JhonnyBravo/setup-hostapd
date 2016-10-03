#!/bin/bash

package_name="hostapd"
script_name=$(basename "$0")
destination="backup"

i_flag=0
g_flag=0

function install_file(){
  if [ -f "${1}/hostapd.conf" ]; then
    install -m 0644 "${1}/hostapd.conf" "/etc/hostapd/hostapd.conf"
  fi

  if [ -f "${1}/hostapd" ]; then
    install -m 0644 "${1}/hostapd" "/etc/default/hostapd"
  fi
}

function usage(){
cat <<_EOT_
NAME
  ${script_name}

USAGE
  ${script_name} -i directory_path
  ${script_name} -g user_name
  ${script_name} -h

DESCRIPTION
  ${package_name} の設定ファイルを一括で取得またはインストールします。

OPTIONS
  -i directory_path
    指定したディレクトリの配下にある
    ${package_name} の設定ファイルをインストールします。

  -g user_name
    ${package_name} の設定ファイルを ./${destination} へコピーし、
    ./${destination} の所有者を指定したユーザへ変更します。

  -h  ヘルプを表示します。
_EOT_
exit 1
}

while getopts "i:g:h" option
do
  case $option in
    i)
      i_flag=1
      ;;
    g)
      g_flag=1
      ;;
    h)
      usage
      ;;
    \?)
      usage
      ;;
  esac
done

shift $((OPTIND -2))

if [ $i_flag -eq 1 ]; then
  install_file "$1"
elif [ $g_flag -eq 1 ]; then
  user_name="$1"

  if [ ! -d "$destination" ]; then
    mkdir "$destination"
  fi

  install -m 0644 "/etc/default/hostapd" "$destination"

  if [ -f "/etc/hostapd/hostapd.conf" ]; then
    install -m 0644 "/etc/hostapd/hostapd.conf" "$destination"
  else
    zcat "/usr/share/doc/hostapd/examples/hostapd.conf.gz" > "${destination}/hostapd.conf"
  fi

  chown -R "${user_name}:${user_name}" "$destination"
fi
