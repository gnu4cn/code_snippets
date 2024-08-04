# 使用 Python Flask（Restful 后端）与 Inoic（前端）开发应用

本文记录使用 Flask 与 Ionic 开发应用的一些问题。



## Flask 框架技巧


1. 在项目中有正确的 `wsgi.py` 或 `app.py` 时，通过 `flask shell`进入一个 CLI。


2. 在利用`uwsgi`与`supervisord`异同部署 Flask 应用时，要同时将环境变量写在`.bashrc`与 Supervisor的配置文件（`/etc/supervisor/conf.d/uwsgi.conf`）中，才能使用`os.getenv`获取到环境变量。

3. `Flask-SocketIO` 与　uWSGI 部署，只能使用　`gevent` 服务器（使用 `eventlet` 不成），且目前只能开一个进程一个线程.

配置文件如下：

```ini
[uwsgi_socket-io]
# pwd
chdir = /home/peng/ccna60d-apis

#虚拟环境环境路径
virtualenv = %v/.venv

socket = %v/uwsgi_socket-io.socket

max-requests = 1000
no-orphans = true

#wsgi文件 run就是flask启动文件去掉后缀名 app是run.py里面的Flask对象 
module = run_socket-io:app

gevent = 1000
http-websockets = true
wsgi-file = run_socket-io.py

#指定工作进程
processes = 1

#主进程
master = true

http = 127.0.0.1:5001

#每个工作进程有2个线程
# enable-threads = true
threads = 1

#保存主进程的进程号
pidfile = %v/uwsgi_socket-io.pid

# https://stackoverflow.com/questions/22752521/uwsgi-flask-sqlalchemy-and-postgres-ssl-error-decryption-failed-or-bad-reco
lazy-apps = true
```

## 解决`ionic serve`不自动编译的问题

需要提升 `fs.inotify.max_user_watches` 参数：

[https://github.com/ionic-team/ionic-app-scripts/issues/1239#issuecomment-342143562](https://github.com/ionic-team/ionic-app-scripts/issues/1239#issuecomment-342143562)

如何提升：

[https://stackoverflow.com/a/32600959/98057](https://stackoverflow.com/a/32600959/98057)





## Ionic 4(Angular) 访问 Flask-Restful API时的CORS问题

此问题是Flask应用服务器未设置 `Access-Control-Allow-Origin` 头所造成的。与 Ionic、Angular、uwsgi、Nginx均没有关系。

> https://stackoverflow.com/questions/26980713/solve-cross-origin-resource-sharing-with-flask

使用 Flask-Cors 可以不修改代码，就解决此问题

> https://github.com/corydolphin/flask-cors

也可以使用 Flask-Restful 自带的装饰器 `crossdomain` 给指定Api限制访问域名

> https://github.com/flask-restful/flask-restful/blob/master/flask_restful/utils/cors.py
