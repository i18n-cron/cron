#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -e

./build.sh
. env.sh
cd ..
set -x
echo $(pwd)
exec node --trace-deprecation $DIR/lib/main.js
