FROM ubuntu:14.04

RUN apt-get update 
RUN apt-get install -y build-essential
RUN apt-get install -y isc-dhcp-server python-ipaddr

copy dhcpd_start.py /

EXPOSE 67
EXPOSE 68

CMD python /dhcpd_start.py
