#!/bin/bash

script_name=$(basename "$0")

function usage(){
cat <<_EOT_
NAME
  ${script_name}

USAGE
  ${script_name} file_name destination [-h]

DESCRIPTION
  ファイルリストに記載された設定ファイルを
  指定したディレクトリへコピーします。
  ファイルリストは ``permission file_path`` の形式で
  記述してください。

OPTIONS
  -h  ヘルプを表示します。
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

file_name="$1"
dst="$2"

if [ ! -d "$dst" ]; then
  mkdir -p "$dst"
fi

if [ -f "$file_name" ]; then
  while read line
  do
    src=$(echo "$line" | awk '{print $2}')

    if [ -f "$src" ]; then
      cp "$src" "$dst"
    fi
  done < "$file_name"
fi

if [ -f "${dst}/hostapd.conf" ]; then
  rm "${dst}/hostapd.conf.gz"
else
  zcat "${dst}/hostapd.conf.gz" > "${dst}/hostapd.conf"
  rm "${dst}/hostapd.conf.gz"
fi
