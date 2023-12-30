#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR
set -ex

./build.sh

if [ ! -n "$1" ]; then
  exec bun --smol run --bun ./lib/main.js
else
  exec ./${@:1}
fi
