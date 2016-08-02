#!/bin/bash
# Scripts builds the container

docker build -t som/tftpd tftpd/.
docker build -t som/dhcpd dhcpd/.

