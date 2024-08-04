# PDKs 上传 SOP


- 上传到 10.11.1.9 中转 FTP 服务器

- 登录 VNC 服务器，10.11.1.13:5999，用户名 penghailin，密码：ATX6teWC

- 运行 rsync 命令：

`rsync -auvzP ~/PDKs/ root@10.10.1.16:/data2/process/tmp/`

> 注：上面是上海 site 的存储地址。

其中 10.10.1.16 是 shfs01 主机的 IP 地址。

- 等待上传完成。
