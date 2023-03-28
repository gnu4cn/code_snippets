# 关于 LDAP 查询

一条典型的 LDAP 查询：

```bash
ldapsearch -x -h ldap://dc.xfoss.com -p 389 -D lenny.peng@xfoss.com -b "CN=Laxers Peng,ou=RnD,dc=xfoss,dc=com" "(objectClass=person)" -w "password"
```

经测试，此命令在 Linux 机器本地用户/域用户登录下，都可使用（通常`ldap-utils`实用工具，都需要域账户登录下，才能使用，因为这些工具，要查询`/tmp/krb5cc_xxx`登录凭据）。

其中 `-D` 后面是域管理用户，普通用户会报错： 

```bash
ldap_bind: Invalid credentials (49)
        additional info: 80090308: LdapErr: DSID-0C09041C, comment: AcceptSecurityContext error, data 52e, v4563
```

其中 `-x` 指定的是简单认证；`-b` 指`basedn`，搜索的 `base dn`；`(objectClass=person)`指的过滤条件；`-w` 直接输入管理员账号的密码（使用`-W`则在稍后提示输入密码）。

> 推测 `python-ldap` 库，是对 `ldap-utils` 的封装。


## LDAP（AD）中的一些术语

- DN: Distinguished Name, 区分名
- CN：Common Name, 用户名/服务器名/计算机名
- OU: Organization Unit，组织单元，最多可以有4级，每级最长32个字符
- DC: Domain Component
