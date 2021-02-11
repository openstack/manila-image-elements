#!/bin/sh

# Preseed slapd options to debconf.
cat << EOF | debconf-set-selections
slapd slapd/internal/adminpw password admin
slapd slapd/domain string example.com
slapd shared/organization string "Example, Inc."
slapd slapd/internal/generated_adminpw password admin
slapd slapd/internal/adminpw password admin
slapd slapd/password2 password admin
slapd slapd/password1 password admin
slapd slapd/dump_database_destdir string /var/backups/slapd-VERSION
slapd slapd/purge_database boolean true
slapd slapd/move_old_database boolean true
slapd slapd/allow_ldap_v2 boolean false
slapd slapd/no_configuration boolean false
slapd slapd/dump_database select when needed
EOF
dpkg-reconfigure -f noninteractive slapd

# Start OpenLDAP.
/usr/sbin/slapd

# Add cn=Administrator and cn=Guest entries.
ldapadd -x -H ldap://localhost:389 -D cn=admin,dc=example,dc=com -w admin << \
EOF
dn: cn=Administrator,dc=example,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: Administrator
uid: Administrator
uidNumber: 1024
gidNumber: 1024
homeDirectory: /home/Administrator
userPassword: Administrator

dn: cn=Guest,dc=example,dc=com
objectClass: top
objectClass: account
objectClass: posixAccount
objectClass: shadowAccount
cn: Guest
uid: Guest
uidNumber: 2048
gidNumber: 2048
homeDirectory: /home/Guest
userPassword: Guest
EOF
