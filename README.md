# ec2-vbox

Simple setup and script to easily create Virtual Box VMs running on OSX


## Download VirtualBox VDI

Get the VDI from [https://cdn.amazonlinux.com/os-images/2.0.20210721.2/virtualbox/](https://cdn.amazonlinux.com/os-images/2.0.20210721.2/virtualbox/)

You can read more about why and how in [the official user guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html)

## Create VM

```sh
./create-vm.sh amzn2-virtualbox-2.0.20210721.2-x86_64.xfs.gpt.vdi vmname
```

The script will create new folder inside `./vms/` with copy of the seedconfigs.

You will be asked if you want to continue with default values. If not, just edit the files and press any key when you are ready.

When the script is done you can launch VirtualBox GUI and start the machine

or you can go headless with:

```sh
VBoxHeadless --startvm vmname
```

