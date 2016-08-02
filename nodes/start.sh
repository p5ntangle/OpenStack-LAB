#!/bin/bash

# DHCP Server
#docker run -d -p 67:67 -p 67:67/udp -p 68:68 -p 68:68/udp -t dhcpd python /dhcpd_start.py
docker run -d --network=host -t som/dhcpd

# tftp server
docker run -d -p 69:69/udp -t som/tftpd

#apache server
#docker run -d -p 80:80 -t -v /tmp:/var/lib/tftpboot pxeboot
