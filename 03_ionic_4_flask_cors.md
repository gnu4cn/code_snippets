# Ionic 4(Angular) 访问 Flask-Restful API时的CORS问题

此问题是Flask应用服务器未设置 `Access-Control-Allow-Origin` 头所造成的。与 Ionic、Angular、uwsgi、Nginx均没有关系。

> https://stackoverflow.com/questions/26980713/solve-cross-origin-resource-sharing-with-flask

使用 Flask-Cors 可以不修改代码，就解决此问题

> https://github.com/corydolphin/flask-cors

也可以使用 Flask-Restful 自带的装饰器 `crossdomain` 给指定Api限制访问域名

> https://github.com/flask-restful/flask-restful/blob/master/flask_restful/utils/cors.py
