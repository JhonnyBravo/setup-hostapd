#!/bin/bash

scripts="scripts"
destination="/usr/local/bin"
i_flag=0
u_flag=0

function usage(){
cat <<_EOT_
Usage:
  ${0} [-i] [-u] [-h]

Description:
  ${scripts} 配下にあるファイルを ${destination} へ
  インストール / アンインストールします。

Options:
  -i ${scripts} 配下にあるファイルを ${destination} へインストールします。
  -u ${scripts} 配下にあるファイルを ${destination} からアンインストールします。
  -h ヘルプを表示します。
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

file_list=$(ls "$scripts")

if [ $i_flag -eq 1 ]; then
  for file in $file_list
  do
    source="${scripts}/${file}"
    install "$source" "$destination"
  done
elif [ $u_flag -eq 1 ]; then
  for file in $file_list
  do
    rm "${destination}/${file}"
  done
fi
