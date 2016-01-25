#!/bin/bash

conf_path="/etc/hostapd/hostapd.conf"
template_path=$(basename $conf_path)

function usage(){
cat <<_EOT_
Usage:
  ${0} [-g] [-i path] [-h]

Description:
  ${conf_path} を取得またはインストールします。

Options:
  -g ${conf_path} を現在のディレクトリへコピーします。
  -i path  path に指定したファイルを
           ${conf_path} へインストールします。
  -h ヘルプを表示します。
_EOT_
exit 1
}

g_flag=0
i_flag=0

while getopts "gi:h" option
do
  case $option in
    g)
      g_flag=1
      ;;
    i)
      i_flag=1
      ;;
    h)
      usage
      ;;
    \?)
      usage
      ;;
  esac
done

if [ $g_flag -eq 1 ]; then
  if [ -f "$conf_path" ]; then
    cat "$conf_path" >"$template_path"
  else
    conf_path="/usr/share/doc/hostapd/examples/hostapd.conf.gz"
    zcat "$conf_path" >"$template_path"
  fi
elif [ $i_flag -eq 1 ]; then
  shift $((OPTIND - 2))

  source="$1"
  install "$source" "$conf_path" -m 0644
fi