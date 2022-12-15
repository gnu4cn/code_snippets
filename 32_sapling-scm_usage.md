# Sapling-SCM 使用说明

## 配置文件

Sapling 配置文件分为三个级别 `user`、`local` 与 `system`，对应了以下三个文件：

- `~/.config/sapling/sapling.conf`
- `path/to/repo/.sl/config`
- `/etc/sapling`

## 修改配置

使用命令 `sl config --[user/local/system] config.item "values"` 来分别修改各个级别的配置文件。比如要设置用户级别的 `http_proxy`，执行以下命令：

```console
$ sl config --user http_proxy.host "192.168.30.51:3128"                                                    lennyp@vm-manjaro
updated config in /home/lennyp/.config/sapling/sapling.conf
$ sl config --user http_proxy.no gitlab.senscomm.com                                                       lennyp@vm-manjaro
updated config in /home/lennyp/.config/sapling/sapling.conf
```

此时在 `~/.config/sapling/sapling.conf` 中的内容如下：

```conf
$ cat ~/.config/sapling/sapling.conf                                                                       lennyp@vm-manjaro
# example user config (see 'sl help config' for more info)
[ui]
# name and email, e.g.
# username = Jane Doe <jdoe@example.com>
username =Lenny Peng <unisko@gmail.com>

# uncomment to disable color in command output
# (see 'sl help color' for details)
# color = never

# uncomment to disable command output pagination
# (see 'sl help pager' for details)
# paginate = never

[lenny]
peng = Lenny Peng <unisko@gmail.com>

[http_proxy]
no = gitlab.senscomm.com

[http_proxy]
host = 192.168.30.51:3128
```
