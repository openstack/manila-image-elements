FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
      iproute2 \
      ldap-utils \
      net-tools \
      samba \
      slapd \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir -p /shares \
    && chmod 0777 /shares \
    && adduser --disabled-password --gecos '' master \
    && (echo 'pwd'; echo 'pwd') | smbpasswd -a -s master \
    && sed -i '/\[global\]/a\   include = registry' /etc/samba/smb.conf

COPY entrypoint.sh /entrypoint.sh
COPY slapd.sh /slapd.sh
RUN chmod +x /entrypoint.sh /slapd.sh

EXPOSE 139 445 389 636

ENTRYPOINT ["/entrypoint.sh"]
