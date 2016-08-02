FROM ubuntu:14.04

RUN apt-get update 
RUN apt-get install -y atftpd
RUN apt-get install -y wget

# add exit state 0 to deal with wget weirdness
#RUN wget -r -nH --cut-dirs 7 --no-parent -e robots=off --reject "index.html*" /var/lib/tftpboot  http://us.archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/ ; exit 0
RUN wget -r -nH --cut-dirs 7 --no-parent -e robots=off --reject "index.html*" http://us.archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/ ; exit 0


EXPOSE 69
EXPOSE 1023:65500

CMD /usr/sbin/in.tftpd --daemon --trace  --no-fork --no-source-port-checking --logfile -  /netboot 
