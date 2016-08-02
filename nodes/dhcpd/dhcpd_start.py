__author__ = 'shaunomeara'


import socket
import fcntl
import struct
import ipaddr
import string
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
subnet = get_ip_mask('eth0')
set=ip.split(".")
net="%s.%s.%s.0" %(set[0],set[1],set[2])
range_s="%s.%s.%s.225" %(set[0],set[1],set[2])
range_e="%s.%s.%s.235" %(set[0],set[1],set[2])

output = "\n\nsubnet %s netmask %s {\n \
  range %s %s; \n \
  filename \"pxelinux.0\"; \n \
}\n" %(net,subnet,range_s,range_e)

print output
with open ("/etc/dhcp/dhcpd.conf","a") as myfile:
    myfile.write(output)

call(["/usr/sbin/dhcpd", "-d"])
