# `mdbook` 与 Nginx 下的服务器管理

`mdbook` 是 Rust 实现的一个类似于 `gitbook` 的文档服务器，通过使用 MarkDown 编写文档，`mdbook` 可将其构建为 HTML、PDF 目标，并可运行 HTTP 服务器，在线提供文档。咱们使用 Nginx 做 `mdbook` 的反向代理，带来高并发、SSL/TLS 等额外功能。

以下是在建立此种文档服务器时，用到的一些配置与脚本。

## 服务器管理脚本


## Nginx 配置示例
