# `mdbook` 与 Nginx 下的服务器管理

[`mdbook`](https://rust-lang.github.io/mdBook/) 是 Rust 实现的一个类似于 `gitbook` 的文档服务器，通过使用 MarkDown 编写文档，`mdbook` 可将其构建为 HTML、PDF 目标，并可运行 HTTP 服务器，在线提供文档。咱们使用 Nginx 做 `mdbook` 的反向代理，带来高并发、SSL/TLS 等额外功能。

以下是在建立此种文档服务器时，用到的一些配置与脚本。

## `include` 自己的一些行

`include` 指令可以重用 Markdown 文档中的一些行。而要从自己 `include` 一些行，可以向下面这样，在 `linux.md` 中写入：

~~~
```
{{#include ./linux.md:119:191}}
```
~~~

便可以引用 `linux.md` 本身的 `119` 到 `191` 行。

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
