#!/usr/bin/env bash

VDI_PATH="$1"
NAME="$2"

if [ -z "$NAME" ] || [ -z "$VDI_PATH" ]; then
  echo "usage: create-vm.sh <vdi-path> <name>"
  exit 1
fi

NEW_VDI="$1.xfs.gpt.vdi"
mkdir -p "./vms/$NAME"

# Prepare Disk
cp "$VDI_PATH" "./vms/$NAME/$NEW_VDI"
VBoxManage internalcommands sethduuid "./vms/$NAME/$NEW_VDI"

# Prepare seed
cp -r ./seedconfig "./vms/$NAME/seedconfig"

# build seed iso
read -p "Do you need to change your seedconfig ? Press any key when you are done..." -n 1 -r
echo
hdiutil makehybrid -o "./vms/$NAME/seed.iso" -hfs -joliet -iso -default-volume-name cidata "./vms/$NAME/seedconfig"

# Create VM
VBoxManage createvm --name "$NAME" --ostype "Linux_64" --register

VBoxManage modifyvm "$NAME" --ioapic on
VBoxManage modifyvm "$NAME" --memory 2048 --vram 128
VBoxManage modifyvm "$NAME" --nic1 nat

VBoxManage storagectl "$NAME" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "$NAME" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium "./vms/$NAME/$NEW_VDI"
VBoxManage storagectl "$NAME" --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach "$NAME" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium "./vms/$NAME/seed.iso"
VBoxManage modifyvm "$NAME" --boot1 dvd --boot2 disk --boot3 none --boot4 none
