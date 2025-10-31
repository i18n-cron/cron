#!/usr/bin/env bash

DIR=$(realpath ${0%/*})
cd $DIR

exec watchexec --shell=none \
  --project-origin . -w ./src \
  -w ./test \
  --exts coffee,js,mjs,json,wasm,txt,yaml \
  -r \
  -- sh -c "./build.sh && ./run.sh"
