#!/usr/bin/env bash

NAME="$1"

if [ -z "$NAME" ]; then
  echo "usage: prepare.sh <vmname>"
  exit 1
fi

mkdir -p "./vms/$NAME"

# Prepare seed
cp -r ./seedconfig "./vms/$NAME/seedconfig"
