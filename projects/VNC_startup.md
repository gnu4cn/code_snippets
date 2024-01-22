# VNC 启动


## 启动


VNC 的启动，是基于每个用户的。在用 SSH 登录了主机后，运行命令：


```console
$ vncserver :x
```

即可启动该用户下的 VNC 服务器，随后即可通过 VNC Viewer 连接到该主机。过程中 VNC 会询问密码。其中 `x` 是 VNC 的端口号。


```console
$ vncserver -geometry 1920x1080 -depth 24 :x
```

其中，`-geometry 1920x1080` 指定了分辨率为 `1920x1080`，`-depth 24` 指定了颜色为 `24` 位。


## 查看 VNC 是否启动


`ps -ef | grep vnc`


## 关掉 VNC


`$ vncserver -kill :x`

其中 `x` 是启动时用到的 VNC 端口号。

## 修改 VNC 分辨率


在 VNC 的配置文件 `/etc/vnc/xstartup` 末尾，添加行：

`xrandr -s 1280x800`

重启 VNC 服务器，就应看到新分辨率生效。
