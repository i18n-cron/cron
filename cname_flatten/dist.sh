#!/usr/bin/env bash

DIR=$(realpath $0) && DIR=${DIR%/*}
cd $DIR
set -ex

./build.sh
rm -rf cname.js
direnv exec . ./esbuild.coffee
chmod +x cname.js
