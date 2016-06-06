FROM phusion/baseimage:0.9.18

EXPOSE 445
EXPOSE 139
EXPOSE 135

CMD ["/sbin/my_init"]

RUN apt-get update && apt-get install -y samba smbclient

RUN mkdir /shares
RUN chmod 0777 /shares

RUN adduser --disabled-password --gecos '' master
RUN (echo pwd; echo pwd) | smbpasswd -a -s master
RUN sed -i "/\[global\]/a\ \ \ include = registry" /etc/samba/smb.conf
RUN apt-get clean

entrypoint ["/usr/sbin/smbd"]
cmd ["-F", "-S"]
