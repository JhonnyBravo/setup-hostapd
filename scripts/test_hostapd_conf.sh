#!/bin/bash

path="/etc/hostapd/hostapd.conf"

function usage(){
cat <<_EOT_
Usage:
  ${0} [-h]

Description:
  $path の動作確認を実行します。

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

hostapd "$path"
