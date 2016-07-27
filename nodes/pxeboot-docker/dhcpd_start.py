__author__ = 'shaunomeara'


import socket
import fcntl
import struct
import ipaddr
from subprocess import call

def get_ip_address(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x8915,  # SIOCGIFADDR
        struct.pack('256s', ifname[:15])
    )[20:24])

def get_ip_mask(ifname):
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    return socket.inet_ntoa(fcntl.ioctl(
        s.fileno(),
        0x891b,  # SIOCGIFNETMASK
        struct.pack('256s', ifname[:15])
    )[20:24])

ip = get_ip_address('eth0')

mask = "255.255.255.255"

output = "\n\nsubnet %s netmask %s {\n}" %(ip,mask)

with open ("/etc/dhcp/dhcpd.conf","a") as myfile:
    myfile.write(output)

call(["/usr/sbin/dhcpd", "-d"])