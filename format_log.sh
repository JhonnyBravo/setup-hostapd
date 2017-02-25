#!/bin/bash

script_name=$(basename "$0")

function usage(){
cat <<_EOT_
NAME
  ${script_name}

USAGE
  ${script_name} path [-h]

DESCRIPTION
  DROP された iptables のログを整形して返します。

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

path="$1"

if [ -f "$path" ]; then
  grep -a DROP "$path" \
    | sed -f replace.sed \
    | sed -f replace2.sed \
    | sed -f remove.sed \
    | tr -d "\n" \
    | sed -e "s/-i/\n-i/g" \
    | sort \
    | uniq
else
  echo "${path} は存在しません。"
fi
