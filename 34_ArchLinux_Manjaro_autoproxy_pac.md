# ArchLinux/Manjaro `autoproxy.pac`

可运用 `autoproxy.pac` 代理自动配置文件，在系统层面设置代理策略，并配合 `～/.curlrc`、`~/.ssh/config` 与 `~/.gitconfig` 文件，让受限流量自动通过使用 `ssh` 建立起的 SOCKS5 端口，实现 `devops` 的效率提升。


## 生成 `autoproxy.pac`

ArchLinux 下有 `python-genpac` 项目，运行 `yay -S python-genpac` 安装。但此项目是为 `python 3.6` 编写，在 `python 3.10` 下存在问题，需要修改文件 `/usr/lib/python3.10/site-packages/genpac/pysocks/socks.py` 中的第 65 行为：

```python
from collections.abc import Callable
```

否则会报出 `import` 错误。

然后创建一个 `GenPAC` 文件夹，于其中建立一个 `user-rules` 文件，其中内容如下：

```txt
@@sina.com
@@163.com
@@*.cn
@@xfoss.com
@@172.105.224.95
pythonhosted.org|
```

PAC 规则与 Adblock 规则一致，`@@` 后的域名不走代理，其他都设置为通过代理连接。

```console
$ genpac --pac-proxy "SOCKS5 127.0.0.1:10080" \
--gfwlist-proxy="SOCKS5 127.0.0.1:10080" \
--output="autoproxy.pac" \
--gfwlist-url="https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt" \
--user-rule-from="user-rules.list"
```

这样便得到一个 `autoproxy.pac` 文件了，然后通过 `lighttp`/`nginx` 在本地假设一个 `http` 服务器，来通过 HTTP 协议提供到这个文件。然后在系统 `设置` -》`网络` -》`代理` -》`自动` 里，填入 `autoproxy.pac` 的 URL 即可实现，系统级别的自动代理了。

## 分别设置 `~/.curlrc`、`~/.ssh/config` 与 `~/.gitconfig`

此时浏览器中可不必安装 `Switchy Omega` 插件了。
