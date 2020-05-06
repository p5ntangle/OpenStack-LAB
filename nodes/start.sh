#!/bin/bash


#create shared volume for boot
#docker volume create -d flocker --name boot-files -o size=2GB

# tftp server
docker run --name tftpd -d -p 69:69/udp -v /root/OpenStack-LAB/nodes/netboot:/netboot -t som/tftpd

# DHCP Server
docker run --name dhcpd -d --network=host -v /root/OpenStack-LAB/nodes/netboot:/netboot -t som/dhcpd

