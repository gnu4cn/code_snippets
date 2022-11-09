# 工作杂记

1. `FortiGate` 报错：`Credential or SSLVPN configuration is wrong. (-7200)`

    ![`FortiGate` - `-7200` 报错](images/20_01.png)

    *图 1 - `FortiGate` - `-7200` 报错*

    AD 账户被禁用造成。

2. 无法远程桌面到另一 Windows 终端的问题

    由于该 Windows 开启了防火墙，导致其他计算机无法远程桌面控制此 Windows 计算机。并表现为从此 Windows 终端可 Ping 通远端计算机，但远端计算机无法 Ping 通此 Windows 计算机。*解决方法*：关闭此计算机的防火墙即可。
