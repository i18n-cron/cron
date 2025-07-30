#!/usr/bin/env bash

DIR=$(realpath ${0%/*})
cd $DIR
set -ex

bun i
direnv exec . ./_dist.coffee
if ! command -v fly &>/dev/null; then
  curl -L https://fly.io/install.sh | sh
fi
fly deploy
