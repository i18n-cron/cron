#!/usr/bin/env bash

DIR=$(dirname $(realpath "$0"))
cd $DIR

set -ex
exec ./lib/snapshot.js
