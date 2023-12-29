#!/usr/bin/env bash

set -o allexport

PWDDIR=$(pwd)

CONF=$(dirname $(realpath $BASH_SOURCE))/conf

set +o allexport

ROOT=$CONF/$TASK
cd $ROOT
for sh in $(find . -type f -name "*.sh"); do
  echo $TASK/$(basename $sh)
  cd $ROOT
  set -o allexport
  source $sh
  set +o allexport
done

cd $PWDDIR
