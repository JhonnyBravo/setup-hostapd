#!/bin/bash

script_name=$(basename "$0")
destination="backup"

i_flag=0
g_flag=0

function get_file_list(){
cat <<_EOT_
/etc/default/ufw 0644
/etc/ufw/sysctl.conf 0644
/etc/ufw/before.rules 0640
_EOT_
}

function install_file(){
  source_list=$(find "${1}")

  for source_path in $source_list
  do
    source_name=$(basename "$source_path")
    install_path=$(get_file_list | grep "$source_name" | awk '{print $1}')
    permission=$(get_file_list | grep "$source_name" | awk '{print $2}')

    if [ -f "$install_path" ]; then
      install -m "$permission" "$source_path" "$install_path"
    fi
  done

  if [ -f "${1}/ufw" ]; then
    install -m 0644 "${1}/ufw" "/etc/default/ufw"
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
  ufw の設定ファイルを一括で取得またはインストールします。

OPTIONS
  -i directory_path
    指定したディレクトリの配下にある
    ufw の設定ファイルをインストールします。

  -g user_name
    ufw の設定ファイルを ./${destination} へコピーし、
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
  file_list=$(get_file_list | awk '{print $1}')

  if [ ! -d "$destination" ]; then
    mkdir "$destination"
  fi

  for file_name in $file_list
  do
    install -m 0644 "$file_name" "$destination"
    chown -R "${user_name}:${user_name}" "$destination"
  done
fi
