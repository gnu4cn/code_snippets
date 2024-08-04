# Linux 配置 Samba 文件共享

Samba 文件共享涉及到以下几个方面：`/etc/hosts` 修改、Kerberos 配置 `/etc/krb5.conf`、Samba 配置 `/etc/samba/smb.conf` 与 `winbindd` — Name Service Switch daemon for resolving names from NT servers 配置 `/etc/nsswitch.conf` 等。中间要运行

```console
$ sudo net ads join -U (AD_admin)
```

将运行 Samba 共享的机器，加入到域中。

## 配置 `/etc/hosts`

```conf
$ cat /etc/hosts
127.0.0.1       localhost
10.12.10.141 sw-build-01.xfoss.com sw-build-01
```


## 配置 `/etc/krb5.conf`

```conf
$ cat /etc/krb5.conf
[libdefaults]
        rdns = false
        default_realm = XFOSS.COM
        dns_lookup_kdc = true
        dns_lookup_realm = false

# The following krb5.conf variables are only for MIT Kerberos.
        kdc_timesync = 1
        ccache_type = 4
        forwardable = true
        proxiable = true

# The following encryption type specification will be used by MIT Kerberos
# if uncommented.  In general, the defaults in the MIT Kerberos code are
# correct and overriding these specifications only serves to disable new
# encryption types as they are added, creating interoperability problems.
#
# The only time when you might need to uncomment these lines and change
# the enctypes is if you have local software that will break on ticket
# caches containing ticket encryption types it doesn't know about (such as
# old versions of Sun Java).

#       default_tgs_enctypes = des3-hmac-sha1
#       default_tkt_enctypes = des3-hmac-sha1
#       permitted_enctypes = des3-hmac-sha1

# The following libdefaults parameters are only for Heimdal Kerberos.
        fcc-mit-ticketflags = true

[realms]
        XFOSS.COM = {
                kdc = 10.12.10.5
                default_domain = xfoss.com
        }
        ATHENA.MIT.EDU = {
                kdc = kerberos.mit.edu
                kdc = kerberos-1.mit.edu
                kdc = kerberos-2.mit.edu:88
                admin_server = kerberos.mit.edu
                default_domain = mit.edu
        }
        ZONE.MIT.EDU = {
                kdc = casio.mit.edu
                kdc = seiko.mit.edu
                admin_server = casio.mit.edu
        }
        CSAIL.MIT.EDU = {
                admin_server = kerberos.csail.mit.edu
                default_domain = csail.mit.edu
        }
        IHTFP.ORG = {
                kdc = kerberos.ihtfp.org
                admin_server = kerberos.ihtfp.org
        }
        1TS.ORG = {
                kdc = kerberos.1ts.org
                admin_server = kerberos.1ts.org
        }
        ANDREW.CMU.EDU = {
                admin_server = kerberos.andrew.cmu.edu
                default_domain = andrew.cmu.edu
        }
        CS.CMU.EDU = {
                kdc = kerberos-1.srv.cs.cmu.edu
                kdc = kerberos-2.srv.cs.cmu.edu
                kdc = kerberos-3.srv.cs.cmu.edu
                admin_server = kerberos.cs.cmu.edu
        }
        DEMENTIA.ORG = {
                kdc = kerberos.dementix.org
                kdc = kerberos2.dementix.org
                admin_server = kerberos.dementix.org
        }
        stanford.edu = {
                kdc = krb5auth1.stanford.edu
                kdc = krb5auth2.stanford.edu
                kdc = krb5auth3.stanford.edu
                master_kdc = krb5auth1.stanford.edu
                admin_server = krb5-admin.stanford.edu
                default_domain = stanford.edu
        }
        UTORONTO.CA = {
                kdc = kerberos1.utoronto.ca
                kdc = kerberos2.utoronto.ca
                kdc = kerberos3.utoronto.ca
                admin_server = kerberos1.utoronto.ca
                default_domain = utoronto.ca
        }

[domain_realm]
        .mit.edu = ATHENA.MIT.EDU
        mit.edu = ATHENA.MIT.EDU
        .media.mit.edu = MEDIA-LAB.MIT.EDU
        media.mit.edu = MEDIA-LAB.MIT.EDU
        .csail.mit.edu = CSAIL.MIT.EDU
        csail.mit.edu = CSAIL.MIT.EDU
        .whoi.edu = ATHENA.MIT.EDU
        whoi.edu = ATHENA.MIT.EDU
        .stanford.edu = stanford.edu
        .slac.stanford.edu = SLAC.STANFORD.EDU
        .toronto.edu = UTORONTO.CA
        .utoronto.ca = UTORONTO.CA
        .xfoss.com = XFOSS.COM
        xfoss.com = XFOSS.COM

[plugins]
       localauth = {
             module = winbind:/usr/lib/x86_64-linux-gnu/samba/krb5/winbind_krb5_localauth.so
             enable_only = winbind
       }
```

## 配置 `/etc/nsswitch.conf`

```conf
$ cat /etc/nsswitch.conf
# /etc/nsswitch.conf
#
# Example configuration of GNU Name Service Switch functionality.
# If you have the `glibc-doc-reference' and `info' packages installed, try:
# `info libc "Name Service Switch"' for information about this file.

passwd:         files systemd sss winbind
group:          files systemd sss winbind
shadow:         files sss
gshadow:        files

hosts:          files mdns4_minimal [NOTFOUND=return] dns
networks:       files

protocols:      db files
services:       db files sss
ethers:         db files
rpc:            db files

netgroup:       nis sss
sudoers:        files sss
automount:      sss
```

## 配置 `/etc/samba/smb.conf`


```conf
$ cat /etc/samba/smb.conf
[global]
#username map = /usr/local/samba/etc/user.map
security = ads
log level = 0
socket options = TCP_NODELAY
winbind enum users = yes
winbind enum groups = no
winbind refresh tickets = yes
winbind use default domain = no
winbind offline logon = yes
# vfs objects = acl_xattr
map acl inherit = yes
store dos attributes = yes
os level = 20
preferred master = no
winbind separator = +
max log size = 50
log file = /var/log/samba/log.%m
dns proxy = no
wins server = dc.xfoss.com
wins proxy = no
template homedir = /home/%U
template shell = /bin/bash
encrypt passwords = yes
idmap config * : backend = autorid
idmap config * : range = 10000-2000000
idmap config XFOSS.COM : schema_mode = rfc2307
idmap config XFOSS : unix_nss_info = yes
idmap config XFOSS : unix_primary_group = yes
kerberos method = secrets and keytab
dedicated keytab file = /etc/krb5.keytab
realm = XFOSS.COM
workgroup = XFOSS
password server = dc.xfoss.com
load printers = no
printing = bsd
printcap name = /dev/null
disable spoolss = yes

[printers]
comment = All Printers
browseable = no
path = /var/spool/samba
printable = yes
guest ok = no
read only = yes
create mask = 0700

# Windows clients look for this share name as a source of downloadable
# printer drivers
[print$]
comment = Printer Drivers
path = /var/lib/samba/printers
browseable = yes
read only = yes
guest ok = no
# Uncomment to allow remote administration of Windows print drivers.
# You may need to replace 'lpadmin' with the name of the group your
# admin users are members of.
# Please note that you also need to set appropriate Unix permissions
# to the drivers directory for these users to have write rights in it
;   write list = root, @lpadmin

[robbie]
comment = share folder - Robbie JIN
browseable = yes
path = /home/robbie.jin/projects
create mask = 0755
directory mask = 0755
public = yes
available = yes
writable = yes
read only = no
valid users = @"XFOSS+Domain Users"
admin users = @"XFOSS+Domain Admins"



[le.wu]
comment = share folder - Le WU
browseable = yes
path = /home/le.wu/workspace
create mask = 0755
directory mask = 0755
public = yes
available = yes
writable = yes
read only = no
valid users = @"XFOSS+Domain Users"
admin users = @"XFOSS+Domain Admins"
```


## 开启各种相关服务

```console
$ sudo systemctl enable --now smbd
$ sudo systemctl enable --now nmbd
$ sudo systemctl enable --now winbind
```

> **注**：`winbind` 必须也要打开，否则共享会失败。



## 为用户设置 Samba 密码

Samba 使用系统上的用户账号，但要为这些账号设置独立的密码：`smbpasswd -a username`。


## 指定 SMB 版本

在 `/etc/samba/smb.conf` 中指定 `max protocol = SMB2`。


> 参考：[RHBA-2013:0338 — samba bug fix and enhancement update](https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/6/html/6.4_technical_notes/samba#RHBA-2013-0338)
