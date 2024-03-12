# NIS 账号管理笔记

本文记录 NIS 账号系统管理笔记。


## 更新用户组信息


登录 NIS 服务器，在其上将某个用户添加到指定组：


```console
usermod -aG xfoss-com zhangjun
```

然后前往 `/var/yp` 目录，运行 `make` 命令将组信息同步到受 NIS 管理的其他机器。
