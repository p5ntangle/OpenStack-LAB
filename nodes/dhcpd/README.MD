DHCPd node Build
--------------

This builds a docker image to act as PXE boot server.

docker build  -t som/dhcpd .

Run the image.

#DHCP Server
#docker run -d -p 67:67 -t pxeboot python /dhcpd_start.py
