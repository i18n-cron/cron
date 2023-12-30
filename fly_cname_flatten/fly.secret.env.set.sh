#!/usr/bin/env zsh

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -e

setenv() {
  eval "v=\"\$$1\""
  echo "$1=$v"
  direnv exec . flyctl secrets set $1="$v"
}

setenv CNAME
