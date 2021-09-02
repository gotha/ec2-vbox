# ec2-vbox

Simple setup and script to easily create Virtual Box VMs running on OSX


## Download VirtualBox VDI

Get the VDI from [https://cdn.amazonlinux.com/os-images/2.0.20210721.2/virtualbox/](https://cdn.amazonlinux.com/os-images/2.0.20210721.2/virtualbox/)

You can read more about why and how in [the official user guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/amazon-linux-2-virtual-machine.html)

## Create VM

Firt prepare the project:

```sh
./prepare.sh vmname
```

If needed edit the seedconfigs in `./vms/vmname/seedconfig`.

When you are ready, execute:

```sh
./build.sh amzn2-virtualbox-2.0.20210721.2-x86_64.xfs.gpt.vdi vmname
```

## Start VM


```sh
VBoxManage startvm "vmname" --type separate
```

or headless like this:

```sh
VBoxHeadless --startvm vmname
```


## Clean up

```sh
VBoxManage unregistervm --delete vmname
rm -rf ./vms/vmname
```
