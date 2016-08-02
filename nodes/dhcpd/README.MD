PXE-Node Build
--------------

This builds a docker image to act as PXE boot server.

docker build  -t pxeboo .

Run the image.

#DHCP Server
docker run -d -p 67:67 -t pxeboot python /dhcpd_start.py
#Apache Server
docker run -d -p 80:80 -t pxeboot