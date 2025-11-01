#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR

set -e
. .envrc
set -x
./lib/main.js
