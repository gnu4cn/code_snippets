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

### 用户自定义规则语法

与 `g*wlist` 相同，使用 [AdBlock Plus 过滤规则](http://adblockplus.org/en/filters)

1. 通配符支持，如 `*.example.com/*` 实际书写时可省略 `*` 为 `.example.com/`；

2. 正则表达式支持，以 `\` 开始和结束， 如 `\[\w]+:\/\/example.com\\`；

3. 例外规则 `@@`，如 `@@*.example.com/*` 满足 `@@` 后规则的地址不使用代理；

4. 匹配地址开始和结尾 `|`，如 `|http://example.com`、`example.com|` 分别表示以 `http://example.com` 开始和以 `example.com` 结束的地址

5. `||` 标记，如 `||example.com` 则 `http://example.com`、`https://example.com`、`ftp://example.com` 等地址均满足条件；

6. 注释 `!` 如 `! Comment`。

配置自定义规则时需谨慎，尽量避免与 `gfwlist` 产生冲突，或将一些本不需要代理的网址添加到代理列表。

规则优先级从高到底为: `user-rule` > `user-rule-from` > `g*wlist`

Tip:

如果生成的是 `.pac` 文件，用户定义规则先于 `g*wlist` 规则被处理。

因此可以在这里添加例外或常用网址规则，或能减少在访问这些网址进行查询的时间, 如下面的例子。

但其它格式如 `wingy`, `dnsmasq` 则无此必要, 例外规则将被忽略, 所有规则将被排序。


```javascript
@@sina.com
@@163.com

twitter.com
youtube.com
||google.com
||wikipedia.org
```

PAC 规则与 Adblock 规则一致，`@@` 后的域名不走代理，其他都设置为通过代理连接。

```console
$ genpac --pac-proxy "SOCKS5 127.0.0.1:10080" \
--gfwlist-proxy="SOCKS5 127.0.0.1:10080" \
--output="autoproxy.pac" \
--gfwlist-url="https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt" \
--user-rule-from="user-rules.list"
```

这样便得到一个 `autoproxy.pac` 文件了，然后通过 `lighttp`/`nginx` 在本地架设一个 `http` 服务器，来通过 HTTP 协议提供到这个文件。然后在系统 `设置` -》`网络` -》`代理` -》`自动` 里，填入 `autoproxy.pac` 的 URL 即可实现，系统级别的自动代理了。

## 设置网络代理为 “自动” 及 `autoconfig-url`

参考：[Set PAC (Proxy Auto-Config) file via bash? [closed]](https://askubuntu.com/a/1046410)

使用以下命令可以设置窗口环境下的此方面设置：

```console
gsettings set org.gnome.system.proxy mode auto
gsettings set org.gnome.system.proxy autoconfig-url 'http://my.prox.org/foo.pac'
```

检查相关设置：

```console
$ gsettings get org.gnome.system.proxy mode
'auto'
$ gsettings get org.gnome.system.proxy autoconfig-url
'http://my.prox.org/foo.pac'
```

## 配置 `~/.curlrc`、`~/.gitconfig` 及 `~/.ssh/config`

因为上一布中所设置 “网络代理”，“自动配置 URL” 属于窗口管理系统级别的设置，因此仍要设置 Curl、Git 与 SSH 各自的代理。


## 生成 `autoproxy.pac` 的脚本

```bash
mkdir gen-pac
cd gen-pac
python3 -m venv .venv
./.venv/bin/activate
pip3 install wheel
pip install -U genpac
curl https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt -o gfwlist.txt

# 生成 autoproxy.pac 的命令
genpac --pac-proxy "SOCKS5 127.0.0.1:10080" \
--gfwlist-proxy "SOCKS5 127.0.0.1:10080" \
-o "/home/unisko/buy-me-a-coffee/src/autoproxy.pac" \
--gfwlist-local "gfwlist.txt" \
--user-rule "/home/unisko/gen-pac/cust.list"
```

## 使用 `autossh` 建立自动重连的 SOCKS5 本地代理

```console
autossh -M 5122 -CqTnfN -D 127.0.0.1:10080 user@HOST -p PORT_NUM
```
