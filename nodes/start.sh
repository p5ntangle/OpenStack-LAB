#!/bin/bash


#create shared volume for boot
docker volume create -d flocker --name boot-files -o size=2GB

# tftp server
docker run -d -p 69:69/udp -v boot-files:/netboot -t som/tftpd

# DHCP Server
docker run -d --network=host -v boot-files:/netboot -t som/dhcpd

