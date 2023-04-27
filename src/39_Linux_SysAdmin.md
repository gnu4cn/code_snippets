# Linux 系统管理

本文记录一些 Linux 系统管理相关笔记。

## `NetworkManager.service` is masked

此问题在 `$ sudo systemctl enable --now NetworkManager.service` 时，会导致失败，报出如下错误：

```console
Failed to enable unit: Unit file /etc/systemd/system/NetworkManager.service is masked.
```

参考 [What is a masked service?](https://askubuntu.com/a/1017315)，可以解除该服务的遮蔽，从而解决问题。

## "Authentication required. System policy prevents WiFi scans"

在使用 X2go 客户端连接到 Linux Mate 桌面时，会遇到这个问题。参考：

- [How do I fix "System policy prevents Wi-Fi scans" error?](https://www.reddit.com/r/gnome/comments/py9ln0/how_do_i_fix_system_policy_prevents_wifi_scans/)

- [xRDP – Cannot connect to WiFi Networks in xRDP session – System policy prevents WiFi scans. How to Fix it !](https://c-nergy.be/blog/?p=16310)

在 `/etc/polkit-1/localauthority/50-local.d/` 下建立一个 `47-allow-wifi-scan.pkla` 策略文件，内容如下：

```plka
[Allow Wifi Scan]
Identity=unix-user:*
Action=org.freedesktop.NetworkManager.wifi.scan;org.freedesktop.NetworkManager.enable-disable-wifi;org.freedesktop.NetworkManager.settings.modify.own;org.freedesktop.NetworkManager.settings.modify.system;org.freedesktop.NetworkManager.network-control
ResultAny=yes
ResultInactive=yes
ResultActive=yes
```

然后运行 `$ sudo systemctl restart polkit.service` 重启该服务，之后问题解决。

## X2Go "Globally allow server-side disabling of the clipboard" 问题

此问题已在 `X2Go` `4.0.1.16` 版本中解决，参考 [Globally allow server-side disabling of the clipboard](https://bugs.x2go.org/cgi-bin/bugreport.cgi?bug=506)

在文件 `/etc/x2go/x2goagent.options` 中，找到 `X2GO_NXAGENT_DEFAULT_OPTIONS+=" -clipboard both"` 这行，将其解除注释，然后根据需要设置 `both`、`client`、`server` 或 `none` 选项。


## "Ehternet device not managed" 问题

在安装 Ubuntu 时，因安装的是服务器版本，而只安装了 `ubuntu-mate-core mate-tweak lxde xfce4` 桌面，重启后发现没有网络连接。
