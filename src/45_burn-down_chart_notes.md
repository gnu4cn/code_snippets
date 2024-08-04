# 燃尽图 burn-down chart 部署笔记


使用 [JerrySievert/github-burndown-chart](https://github.com/JerrySievert/github-burndown-chart) 部署一个燃尽图 web app 时，进行了以下修改，以在同一域名下，支持多个项目的燃尽图。


1. 修改 `app.coffee` 与 `config.yml`，支持 node 服务器端口指定。


`app.coffee` 修改行：

```javascript
    app.start process.env.PORT, (err) ->
```

为：


```javascript
    app.start Issues.config.port || process.env.PORT, (err) ->
```

以优先使用 `config.yml` 中的 `port` 设置。


2. 修改 `config.yml`，添加一行 `port: number`，供 `app.coffee` 脚本使用。


3. Nginx 的配置文件


```conf

map $http_upgrade $connection_upgrade {
        default upgrade;
        '' close;
}

server {
        server_name bchart.xfoss.com;

        location /wise/ {
                proxy_set_header   X-Real-IP $remote_addr;
                proxy_set_header   Host      $http_host;
                proxy_pass              http://127.0.0.1:39681/;
        }

        error_page 500 502 503 504 /502.html;

        location /502.html {
                root /var/www/html;
        }

        listen 443 ssl; # managed by Certbot
        ssl_certificate /etc/ssl/certs/xfoss/cert_chain.pem;
        ssl_certificate_key /etc/ssl/certs/xfoss/private.key;
}
```

注意其中 `location` 指令后的 `/wise/`，与 `proxy_pass` 指令后的 `http://127.0.0.1:39681/` 末尾均带有 `/`。其中 `39681` 是 node 服务器监听的端口。
