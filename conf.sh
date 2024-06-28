#!/usr/bin/env bash

PWDDIR=$(pwd)

set -o allexport

CONF=$(dirname $(realpath $BASH_SOURCE))/conf

set +o allexport

ROOT=$CONF/$TASK
cd $ROOT

for sh in $(find . \( -type f -o -type l \) -name "*.sh"); do
  echo $TASK/$(basename $sh)
  cd $ROOT
  set -o allexport
  source $sh
  set +o allexport
done

cd $PWDDIR
