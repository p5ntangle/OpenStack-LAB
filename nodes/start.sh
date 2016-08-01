#!/bin/bash

# DHCP Server
docker run -d -p 68:68 -t pxeboot python /dhcpd_start.py

# tftp server
docker run -d -p 69:69 -t -v /tmp:/var/lib/tftpboot pxeboot /usr/sbin/in.tftpd -L -vvvv

#apache server
docker run -d -p 80:80 -t -v /tmp:/var/lib/tftpboot pxeboot
