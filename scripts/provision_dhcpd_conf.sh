#!/bin/bash

default_path="/etc/dhcp/dhcpd.conf"
file_name=$(basename ${default_path})

g_flag=0
s_flag=0
h_flag=0

g_description=$(
  cat <<_EOT_
  -g directory_path   ${default_path} を
                      directory_path へコピーします。
_EOT_
)

s_description=$(
  cat <<_EOT_
  -s template_path   template_path を
                     ${default_path} へインストールします。
_EOT_
)

h_description="  -h ヘルプを表示します。"

function get_usage(){
  cat <<_EOT_
Usage:
  ${0} -g directory_path
  ${0} -s template_path
  ${0} -h

Description:
  ${default_path} をコピーまたはインストールします。

Options:
${g_description}
${s_description}
${h_description}
_EOT_

exit 1
}

while getopts "g:s:h" option
do
  case $option in
    g)
      g_flag=1
      ;;
    s)
      s_flag=1
      ;;
    h)
      h_flag=1
      ;;
    \?)
      h_flag=1
      ;;
  esac
done

shift $((OPTIND - 2))

if [ $g_flag -eq 1 ]; then
  directory_name="$1"
  cat "$default_path" > "${directory_name}/${file_name}"
elif [ $s_flag -eq 1 ]; then
  source_path="$1"
  install "$source_path" "$default_path" -m 0644
elif [ $h_flag -eq 1 ]; then
  get_usage
fi
