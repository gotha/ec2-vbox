#!/usr/bin/env bash

VDI_FILE_PATH="$1"
NAME="$2"

if [ -z "$NAME" ] || [ -z "$VDI_FILE_PATH" ]; then
  echo "usage: create-vm.sh <vdi-path> <name>"
  exit 1
fi

PROJECT_DIR="./vms/$NAME"
NEW_VDI_FILE_NAME="$1.xfs.gpt.vdi"
NEW_VDI_FILE_PATH="$PROJECT_DIR/$NEW_VDI_FILE_NAME"
SEEDCONFIG_PATH="$PROJECT_DIR/seedconfig"
SEED_ISO_PATH="$PROJECT_DIR/seed.iso"

if [ ! -d "$PROJECT_DIR" ]; then
  echo "$PROJECT_DIR does not exist; Maybe you should run ./prepare.sh first"
  exit 1
fi

if [ ! -f "$VDI_FILE_PATH" ]; then
  echo "$VDI_FILE_PATH does not exist"
  exit 1
fi

# Prepare Disk
if [ -f "$NEW_VDI_FILE_PATH" ]; then
  echo "Disk already exists; removing it ..."
  rm "$NEW_VDI_FILE_PATH"
fi
cp "$VDI_FILE_PATH" "$NEW_VDI_FILE_PATH"
VBoxManage internalcommands sethduuid "$NEW_VDI_FILE_PATH"

# build seed iso
if [ -f "$SEED_ISO_PATH" ]; then
  echo "seed.iso already exists; removing it ..."
  rm "$SEED_ISO_PATH"
fi
hdiutil makehybrid -o "$SEED_ISO_PATH" -hfs -joliet -iso -default-volume-name cidata "$SEEDCONFIG_PATH"

# Create VM
VBoxManage createvm --name "$NAME" --ostype "Linux_64" --register

VBoxManage modifyvm "$NAME" --ioapic on
VBoxManage modifyvm "$NAME" --memory 2048 --vram 128
VBoxManage modifyvm "$NAME" --nic1 nat

VBoxManage storagectl "$NAME" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "$NEW_VDI_FILE_PATH"
VBoxManage storagectl "$NAME" --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach "$NAME" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "$SEED_ISO_PATH"
VBoxManage modifyvm "$NAME" --boot1 dvd --boot2 disk --boot3 none --boot4 none
