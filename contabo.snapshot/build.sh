#!/usr/bin/env bash
DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

rm -rf lib

rsync -av --include='*/' \
  --include='*.js' \
  --include='*.mjs' \
  --exclude=* src/ lib/ &

bunx cep -o lib -c src &

wait || \
  {
    echo "error : $?" >&2
    exit 1
  }

