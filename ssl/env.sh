#!/usr/bin/env bash

DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
cd $DIR

set -o allexport
TASK=$(basename $DIR) source ../conf.sh
set +o allexport
