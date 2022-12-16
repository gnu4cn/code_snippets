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

4. M$/Windows DHCP 服务器管理器

    “设置” -> “Windows 设置” -> “应用” -> “可选功能” -> “添加功能” -> “RSAT: xxx” 组别

    RSAT，Remote Server Administration Tools, 远端服务器管理工具

5. AnyDesk `Aborted(core dumped)` 问题


    该问题初步认为是由于安装 AnyDesk 时使用了 `$ sudo su -`，安装结束后未退出 `root` 用户，就运行了 `anydesk` 命令，在用户主目录下建立了 `.anydesk` 文件夹，所以因为权限原因，而报出 `Aborted(core dumped)` 错误。

    解决办法即是删除主目录下的 `.anydesk` 文件夹。

    参考：[Anydesk error: Aborted (core dumped) in Ubuntu 22.04](https://askubuntu.com/a/1413795`)

6. `curl` 永久代理

    参考 [Set Up cURL to Permanently Use a Proxy](https://www.baeldung.com/linux/curl-permanent-proxy)

    由于许多软件项目在构建时，都会使用 Curl 下载依赖项，因此就要想办法配置 Curl 使用代理，简单的做法是创建一个 `~/.curlrc` 文件，将代理写入到这个文件中：

    ```conf
    proxy=socks5h://localhost:10080
    ```
