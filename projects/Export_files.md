# R&D 文件导出

此 SOP 描述一种使用 `lsyncd` 和 `vsftpd` 从 R&D 区域，导出文件到 OA 区域的方法。

- 登录 NetApp 服务器（ksfs02, 10.11.1.94），创建 `/nihome/username` 目录

    Qtree -> 添加 -> username, vol(nishome), 配置配额（Qtree 配额 -> 限制...... -> 大小Size）

+ 登录 NIS 服务器，创建账号
    - 创建账号：`useradd -s /bin/csh -d /nishome/username -g SWITCH username`
    - 修改密码：`passwd username`
    - 使账号生效：`cd /var/yp && make`

- 修改 `/nishome/username` 权限：`chown username:SWITCH /nishome/username && chmod 750 /nishome/username`

至此设置完成。
