FROM ubuntu:14.04

RUN apt-get update 
RUN apt-get install -y openssh-server build-essential
RUN apt-get install -y apache2 tftpd-hpa inetutils-inetd

# set tftp server to start correctly
RUN set -xe \
	\
	&& cp /etc/default/tftpd-hpa ~/tftpd-hpa \
	&& echo RUN_DAEMON=\"yes\" >> /etc/default/tftpd-hpa

# Configure DHCP server
RUN set -xe \
	&& echo "# PXE Boot Server Config" > /etc/dhcp/dhcpd.conf \
	&& echo "default-lease-time 600;" >> /etc/dhcp/dhcpd.conf \
	&& echo "max-lease-time 7200;" >> /etc/dhcp/dhcpd.conf \
	&& echo "   " >> /etc/dhcp/dhcpd.conf \
	&& echo "subnet 192.168.0.0 netmask 255.255.255.0 {" >> /etc/dhcp/dhcpd.conf \
	&& echo "        range 192.168.0.100 192.168.0.200;" >> /etc/dhcp/dhcpd.conf \
	&& echo "        filename \"pxelinux.0\";" >> /etc/dhcp/dhcpd.conf \
	&& echo "}" >> /etc/dhcp/dhcpd.conf 

# add exit state 0 to deal with wget weirdness
RUN wget -r -nH --cut-dirs 7 --no-parent -e robots=off --reject "index.html*" /var/lib/tftpboot  http://us.archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/ ; exit 0


