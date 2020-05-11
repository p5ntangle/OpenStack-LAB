FROM ubuntu:18.04

RUN apt-get update 
RUN apt-get install -y build-essential
RUN apt-get install -y isc-dhcp-server python-ipaddr
RUN apt-get install -y python3-watchdog python3

copy dhcpd_start.py /
copy watch.py /

EXPOSE 67
EXPOSE 68

#CMD ["python", "/dhcpd_start.py" ]
