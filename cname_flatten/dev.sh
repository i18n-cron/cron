#!/usr/bin/env bash

DIR=$(realpath ${0%/*})
cd $DIR

exec mise exec -- dev $@
