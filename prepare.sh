#!/usr/bin/env bash

NAME="$1"

if [ -z "$NAME" ]; then
  echo "usage: prepare.sh <vmname>"
  exit 1
fi

mkdir -p "./config/$NAME"

# Prepare seed
cp -r ./seedconfig "./config/$NAME/seedconfig"
