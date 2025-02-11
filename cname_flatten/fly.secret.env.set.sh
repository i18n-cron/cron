#!/usr/bin/env zsh

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -e

setenv() {
  for i in "$@"; do
  eval "v=\"\$$i\""
  echo "$i=$v"
  direnv exec . flyctl secrets set $i="$v"
  done
}


direnv exec . flyctl secrets set NODE_TLS_REJECT_UNAUTHORIZED=0

setenv HW_AK HW_SK
