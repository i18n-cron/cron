#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

./build.sh
exec direnv exec . node --trace-deprecation ./lib/main.js
