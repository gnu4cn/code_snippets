# The Way of Getting Github.com Access Through Our Own HTTP Proxy

Since yesterday afternoon, we found that the access to github.com suddenly lost, through some un-official source, we think it’s due to the GFW. Now we tested a solution to get the github.com access back with our own HTTP proxy.

First please install the `ncat`/`socat` tool, with

- `pacman -S/yum|apt|brew|choco install nmap-ncat/ncat/nmap`

- `pacman -S/yum|apt|brew install socat`

Then put the following configuration into the file `~/.ssh/config`(if there is no the file, you should create it by hand.):

```conf
Host github.com
	Hostname github.com
	ServerAliveInterval 55
	ForwardAgent yes
	ProxyCommand /usr/bin/ncat --proxy 192.168.30.51:3128 %h %p
    # ProxyCommand /usr/bin/socat - PROXY:192.168.30.51:%h:%p,proxyport=3128
    # ProxyCommand /usr/bin/nc -X 5 -x 127.0.0.1:10080 %h %p
```

> `netcat`（或 `nc`） 支持的代理协议：`4`(SOCKS v.4)、`5`(SOCKS v.5) 与 `connect`(HTTPS proxy)。参见：[`man netcat`](http://man.he.net/man1/netcat)。

## Settings under OS/Windows

Under M$ Windows OS, It's a little bit different with GNU/Linux. We need install the [Chocolate package manager for Windows](https://chocolatey.org/) within an administrative Powershell window.

```powershell
PS C:\Windows\system32> Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
```

Then, install the `nmap` package with `choco.exe`:

```powershell
PS C:\Windows\system32> choco install nmap
```

We need install the [Git-SCM for Windows](https://git-scm.com/) to the `git` and Minimalist GNU for Windows, MinGW environment. After Git-SCM for Windows installed, we can now launch a `Git Bash` window, from right clicking the Windows `Start` button. From the `Git Bash` window, we can find the newly install `ncat` command location with `which ncat`, which returns the following output:

```console
$ which ncat
/c/Program Files (x86)/Nmap/ncat
```

So, the `~/.ssh/config` file should contain the following content now:

```config
Host github.com
	Hostname github.com
	ServerAliveInterval 55
	ForwardAgent yes
	ProxyCommand "/c/Program Files (x86)/Nmap/ncat" --proxy 192.168.30.51:3128 %h %p
    # ProxyCommand /usr/bin/socat - PROXY:192.168.30.51:%h:%p,proxyport=3128
    # ProxyCommand /usr/bin/nc -X 5 -x 127.0.0.1:10080 %h %p
```

As the same with GNU/Linux OS，we should generate the SSH keys with `ssh-keygen -t rsa`, and put the `~/.ssh/id_rsa.pub` file content into the [GitHub SSH keys](https://github.com/settings/keys)。

Now you get the github.com SSH traffic proxied under Windows OS platform!


> **Note**：in the last `ProxyCommand` statement, the `-X 5` stands for SOCKS version 5, and the `-x` presents using the SOCKS proxy. Source: [How can I use SSH with a SOCKS 5 proxy?](https://superuser.com/a/454211)

If any question, please feel free to contact Ryan or me.

## Git HTTP Proxy Settings

To make git http traffic(only for github.com) proxied, run the following commands:

```console
$ git config --global http.https://github.com.proxy http://192.168.30.51:3128
```

Or for the socks5 proxy:

```console
$ git config --global http.https://github.com.proxy socks5://127.0.0.1:10080
```

It will modify the file `~/.gitconfig` like this:

```conf
$ cat ~/.gitconfig                                                                        lennyp@vm-manjaro
[user]
        email = lenny.peng@xfoss.com
        name = Lenny Peng
[pull]
        rebase = false
[core]
        compression = 0
[http]
        postBuffer = 1048576000
        maxRequestBuffer = 100M
[http "https://github.com"]
        proxy = http://192.168.30.51:3128
```

## 使用 `git` 命令时使用指定的 SSH 私钥

修改 `~/.ssh/config` 文件，使其形如下面这样：

```config
cat ~/.ssh/config
Host github-work
    HostName github.com
    IdentityFile ~/.ssh/id_rsa_work

Host github-personal
    HostName github.com
    IdentityFile ~/.ssh/id_rsa_personal
```

然后这样运行 `git` 命令：

```bash
git clone git@github-work:corporateA/webapp.git
```

就会使用 `~/.ssh/id_rsa_work` 的私钥，而运行下面的 `git` 命令：

```bash
git clone git@github-personal:bob/blog.git
```

则会使用 `~/.ssh/id_rsa_personal` 的私钥。



## `curl` 永久代理

参考 [Set Up cURL to Permanently Use a Proxy](https://www.baeldung.com/linux/curl-permanent-proxy)

由于许多软件项目在构建时，都会使用 Curl 下载依赖项，因此就要想办法配置 Curl 使用代理，简单的做法是创建一个 `~/.curlrc` 文件，将代理写入到这个文件中：

```conf
proxy=socks5h://localhost:10080
```


## OpenWRT 设置

主要使用 `autossh`、`polipo` 与 Web 代理自动发现，Web Proxy Auto-Discovery 协议。


- `autossh`
    用于从 SSH 隧道，建立 SOCKS5 端口。安装 `autossh` 后，会建立 `/etc/init.d/autossh` 服务，和 `/etc/conf/autossh` 配置文件。

- `polipo`
    用于将 SOCKS5 代理，转换为 HTTP 代理。

- WPAD
    通过 `dnsmasq` 的 DHCP 服务器通告选项 `list dhcp_option '252,http://example.com/proxy.pac'`，将 `autoproxy.pac` 文件提供给联网设备。
