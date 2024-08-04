# `mdbook` 与 Nginx 下的内容发布 Web 站点管理

[`mdbook`](https://rust-lang.github.io/mdBook/) 是 Rust 实现的一个类似于 `gitbook` 的文档服务器，通过使用 MarkDown 编写文档，`mdbook` 可将其构建为 HTML、PDF 目标，并可运行 HTTP 服务器，在线提供文档。咱们使用 Nginx 做 `mdbook` 的反向代理，带来高并发、SSL/TLS 等额外功能。

以下是在建立此种文档服务器时，用到的一些配置与脚本。

## `include` 自己的一些行

`include` 指令可以重用 Markdown 文档中的一些行。在 `linux.md` 中写下双花括号括起来的 `#include ./linux.md:119:191` 便可以引用 `linux.md` 本身的 `119` 到 `191` 行。

## 服务器管理脚本

文件：`srv_incl.sh`

```bash
{{#include ../projects/srv_incl.sh}}
```

文件：`srv_mgt.sh`

```bash
{{#include ../projects/srv_mgt.sh}}
```


## Nginx 配置示例


文件：`/etc/nginx/nginx.conf`

```conf
{{#include ../projects/nginx.conf}}
```

文件：`/etc/nginx/conf.d/ccna60d.conf`


```conf
{{#include ../projects/ccna60d.conf}}
```


## 一个域名下多本书的配置

此需要是通过 Nginx 反向代理中，URL 重写的设置实现的。相较于一个域名一本书的 Nginx 设置，略有差别。

```conf
upstream docs-root { server 127.0.0.1:10446; }
upstream xiaohu-zh { server 127.0.0.1:10447; }
upstream xiaohu-en { server 127.0.0.1:10448; }

server {
        server_name docs.xfoss.com;

        location / {
                proxy_pass http://docs-root;
        }

        location /xiaohu/zh/ {
                proxy_pass http://xiaohu-zh/;
        }

        location /xiaohu/en/ {
                proxy_pass http://xiaohu-en/;
        }

        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_cache_bypass $http_upgrade;



        listen 443 ssl;
        ssl_certificate /etc/ssl/certs/xfoss/cert_chain.pem;
        ssl_certificate_key /etc/ssl/certs/xfoss/private.key;
}
```

其中，差别在于这里：

```conf
        location /xiaohu/zh/ {
                proxy_pass http://xiaohu-zh/;
        }
```

`proxy_pass http://xiaohu-zh/` 最后多了一个斜杠。


> 参考：[Nginx reverse proxy + URL rewrite](https://serverfault.com/a/870620)


## 单个域名下同步单个仓库，提供多本书的操作流程

1. 在代码仓库根目录下建立一本新书对应的目录。此目录下应有 `src`、`theme` 目录及 `book.toml` 文件等必要组成部分，所有内容的 MarkDown 文件都在 `src` 目录下；

2. 修改 `src_inc.sh` 文件，添加上面新书的目录，以及新书的端口；

3. 修改 Nginx 的配置文件 `/etc/nginx/config.d/docs.conf`，添加新书的 `upstream` 设置及反向代理路径；

4. 运行 `srv_mgt.sh start demo-book &` 及 `systemctl restart nginx` 启动新书，并重启 Nginx。
