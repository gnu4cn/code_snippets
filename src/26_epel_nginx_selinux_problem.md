# Nginx 与 SeLinux 的问题

在部署 EPEL 镜像的过程中，发现 nginx 配置一切正常，但无法列出文件，百思不得其解。后来在 stackoverflow 上找到答案。[这里](https://stackoverflow.com/a/30952561)，发现是 SeLinux 造成的后，google "selinux nginx"，来到 [Using NGINX and NGINX Plus with SELinux - nginx.com](https://www.nginx.com/blog/using-nginx-plus-with-selinux/)。问题解决。

不过在经上述设置后，仍然会得到 `403: Forbidden` 报错，需按照 [这里](https://stackoverflow.com/a/26228135) 进行设置。


附 同步 EPEL 镜像脚本：

```bash
{{#include ../projects/epel_rsync.sh}}
```

Nginx 配置文件：

```conf
server {
    listen       80;
    server_name  10.12.7.136;

    #access_log  /var/log/nginx/host.access.log  main;
    root /var/mirrors/epel;

    location / {
        autoindex on;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }

}
```
