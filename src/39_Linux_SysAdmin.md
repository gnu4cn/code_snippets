# Linux 系统管理

本文记录一些 Linux 系统管理相关笔记。

## `NetworkManager.service` is masked

此问题在 `$ sudo systemctl enable --now NetworkManager.service` 时，会导致失败，报出如下错误：

```console
Failed to enable unit: Unit file /etc/systemd/system/NetworkManager.service is masked.
```

参考 [What is a masked service?](https://askubuntu.com/a/1017315)，可以解除该服务的遮蔽，从而解决问题。
