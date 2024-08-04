# InvenTree 部署笔记

InvenTree 是一款开源库存管理系统，可提供直观的零件管理和库存控制。InvenTree 功能广泛，是企业和业余爱好者的理想选择。InvenTree 的设计具有可扩展性，并提供与外部应用程序集成或添加自定义插件的多种选项。


## `InvenTree/config.yaml` 中数据库密码的问题

若 `src/InvenTree/config.yaml` 中的 `database.PASSWORD` 配置，是个纯数字，那么就要用 `''` 或 `""` 将其括起来，否则会报出错误：


```console
TypeError: quote_from_bytes() expected bytes
```

参考：[quote_from_bytes() expected bytes错误及其中一个原因](https://blog.csdn.net/weixin_45642669/article/details/126642640)


## `InvenTree/config.yaml` 格式问题


`.yaml` 配置文件的格式，需要使用与 Python 源码中类似的缩进，表示不同的小节。

## 创建数据库

需要指定 `inventree` 数据库的 `OWNER` 为所创建的数据库用户。


## `supervisord` 配置

- `/etc/supervisor/supervisord.conf`

```console
$ cat /etc/supervisor/supervisord.conf
[supervisord]
; Change this path if log files are stored elsewhere
logfile=/home/inventree/log/supervisor.log
user=inventree

[supervisorctl]

[inet_http_server]
port = 127.0.0.1:9001

[include]
files=/etc/supervisor/conf.d/*.conf

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface
```

- `/etc/supervisor/conf.d/inventree.conf`

```console
$ cat /etc/supervisor/conf.d/inventree.conf
; InvenTree Web Server Process
[program:inventree-server]
user=inventree
directory=/home/inventree/src/InvenTree
command=/home/inventree/.venv/bin/gunicorn -c gunicorn.conf.py InvenTree.wsgi -b 10.11.0.105:8000
startsecs=10
autostart=true
autorestart=true
startretries=3
; Change these paths if log files are stored elsewhere
stderr_logfile=/home/inventree/log/server.err.log
stdout_logfile=/home/inventree/log/server.out.log

; InvenTree Background Worker Process
[program:inventree-cluster]
user=inventree
directory=/home/inventree/src/InvenTree
command=/home/inventree/.venv/bin/python manage.py qcluster
startsecs=10
autostart=true
autorestart=true
; Change these paths if log files are stored elsewhere
stderr_logfile=/home/inventree/log/cluster.err.log
stdout_logfile=/home/inventree/log/cluster.out.log
```
