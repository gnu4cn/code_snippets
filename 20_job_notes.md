# 工作杂记

1. `FortiGate` 报错：`Credential or SSLVPN configuration is wrong. (-7200)`

    ![`FortiGate` - `-7200` 报错](images/20_01.png)

    *图 1 - `FortiGate` - `-7200` 报错*

    AD 账户被禁用造成。

2. 无法远程桌面到另一 Windows 终端的问题

    由于该 Windows 开启了防火墙，导致其他计算机无法远程桌面控制此 Windows 计算机。并表现为从此 Windows 终端可 Ping 通远端计算机，但远端计算机无法 Ping 通此 Windows 计算机。*解决方法*：关闭此计算机的防火墙即可。

3. 远程连接到 Linux 主机方案 - X2go

    [X2Go - everywhere@home](https://wiki.x2go.org)

    使用 X2go 无法连接到 Gnome-shell, 原因：[The problem is with Gnome, installing Xfce works well.](https://unix.stackexchange.com/a/322350)

    在较新版本的 Gnome 上（CentOS 7），需要安装 `gnome-flashback` 软件包，先要添加下面这个软件仓库：

    ```repo
    [copr:copr.fedorainfracloud.org:yselkowitz:gnome-flashback]
    name=Copr repo for gnome-flashback owned by yselkowitz
    baseurl=https://download.copr.fedorainfracloud.org/results/yselkowitz/gnome-flashback/epel-7-$basearch/
    type=rpm-md
    skip_if_unavailable=True
    gpgcheck=1
    gpgkey=https://download.copr.fedorainfracloud.org/results/yselkowitz/gnome-flashback/pubkey.gpg
    repo_gpgcheck=0
    enabled=1
    enabled_metadata=1
    ```

    到文件 `/etc/yum.repos.d/yselkowitz-gnome-flashback-epel-7.repo`，再执行：`$ sudo yum install gnome-flashback -y`。

    随后即可通过 `X2Go` 连接到 Gnome 桌面了。
