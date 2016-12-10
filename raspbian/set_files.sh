#!/bin/bash

script_name=$(basename "$0")

function usage(){
cat <<_EOT_
NAME
  ${script_name}

USAGE
  ${script_name} file_name source [-h]

DESCRIPTION
  指定したディレクトリ内の設定ファイルを
  ファイルリストに記載されたパスへコピーします。
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
src_dir=$(echo "$2" | sed -e "s/\/$//")

if [ -f "$file_name" ]; then
  while read line
  do
    permission=$(echo "$line" | awk '{print $1}')
    dst=$(echo "$line" | awk '{print $2}')
    src_file=$(basename "$dst")
    src="${src_dir}/${src_file}"

    if [ -f "$src" ]; then
      install -m "$permission" "$src" "$dst"
    fi
  done < "$file_name"
fi
