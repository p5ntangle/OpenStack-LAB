#!/bin/bash

vmname=zabbix
vmdomain=cloud.bcx.co.za
disksize=40
vcpus=8
ram=8192
diskpath="/var/lib/libvirt/images/"
bridge="boot-net"
vmipaddress=192.168.0.5
vmask=255.255.255.0
vmgate=192.168.0.1
inst_loc="http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/"
initrd="current/images/netboot/ubuntu-installer/amd64/initrd.gz"

virt-install --name=${vmname} --vcpus=${vcpus} --ram=${ram} --os-type=linux \
--os-variant=ubuntuprecise --disk path=${diskpath}${vmname}.img,bus=virtio,size=${disksize},sparse=false \
--accelerate --graphics vnc --noautoconsole --wait=-1 --hvm --autostart \
--network network=${bridge},model=virtio \
--location=${inst_loc} \
--extra-args="auto=true priority=critical vga=788 languagechooser/language-name=English countrychooser/shortlist=US console-keymaps-at/keymap=en netcfg/disable_autoconfig=true netcfg/disable_dhcp=true netcfg/choose_interface=eth0 netcfg/get_ipaddress=${vmipaddress} netcfg/get_netmask=${vmask} netcfg/get_gateway=${vmgate} netcfg/get_nameservers=8.8.8.8 DEBCONF_DEBUG=developer hostname=${vmname} netcfg/get_domain=${vmdomain} initrd=${initrd} -- preseed/url=http://192.168.0.200/preseed/stack.cfg"

