# Sapling-SCM 使用说明

## 安装问题

在运行 `yay -S sapling-scm` 时，报出了以下问题：

```console

[2/4] Fetching packages...
error An unexpected error occurred: "/home/peng/.cache/yarn/v6/npm-ignore-5.2.0-6d3bac8fa7fe0d45d9f9be7bac2fc279577e345a-integrity/node_modules/ignore/.yarn-metadata.json: Unexpected end of JSON input".
info If you think this is a bug, please open a bug report with the information provided in "/home/peng/.cache/yay/sapling-scm/src/sapling-0.1.20221201-095354-r360873f1/addons/yarn-error.log".
info Visit https://yarnpkg.com/en/docs/cli/install for documentation about this command.
```

此时运行 `yarn cache clean` 后再度安装即可。

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

