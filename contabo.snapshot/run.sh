#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR

set -ex
exec direnv exec . ./lib/main.js
