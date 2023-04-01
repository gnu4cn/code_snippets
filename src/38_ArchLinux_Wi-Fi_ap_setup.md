# ArchLinux/Manjaro 上 Wi-Fi AP 设置

在 Linux 系统中，无线访问点设置是经由 `hostapd` 实现的。但在 `hostapd` 能运行之前，先要建立一个桥接接口（NAT 接口也是可以的，但其中涉及到 `dhcp` 服务器设置，故这里暂且不涉及）。


## 建立一个桥接接口

建立桥接接口的办法有好几种，这里用最简单的 `nmcli` 命令工具。步骤如下：

```console
// 建立一个 br0
$ nmcli connection add type bridge ifname br0 stp no
// 建立一个 bridge-slave-enp2s0
$ nmcli connection add type bridge-slave ifname enp2s0 master br0
// 启动 bridge-br0
$ nmcli connection up bridge-br0
// 启动 bridge-slave-enp2s0
$ nmcli connection up bridge-slave-enp2s0
```

此时运行 `nmcli connection show --active`，输出如下：

```console
NAME                  UUID                                  TYPE      DEVICE 
HUAWEI-Z4BWQD_HiLink  18416b90-7d70-4dc9-a313-9684662ed80b  wifi      wlp3s0 
bridge-br0            13475570-a30c-4a75-a11b-90ed862aea70  bridge    br0    
lo                    7ec52291-032f-4ec4-957a-37d18367ae2f  loopback  lo     
bridge-slave-enp2s0   364b93ac-eaa6-487f-a93f-5953cefa5a79  ethernet  enp2s0 
```

终端中第一行显示为黄色，其他行为绿色。绿色表示连接已运行。而运行 `ifconfig` 命令，输出则为如下：


```console
br0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 192.168.1.6  netmask 255.255.255.0  broadcast 192.168.1.255
        inet6 2408:823d:4c12:7504:ba58:d24b:e97d:af9a  prefixlen 64  scopeid 0x0<global>
        inet6 fe80::432e:7f1d:8734:6d8c  prefixlen 64  scopeid 0x20<link>
        ether 7e:25:03:94:3a:8e  txqueuelen 1000  (Ethernet)
        RX packets 2673  bytes 2256331 (2.1 MiB)
        RX errors 0  dropped 96  overruns 0  frame 0
        TX packets 2516  bytes 384021 (375.0 KiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

enp2s0: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether 50:eb:f6:50:59:58  txqueuelen 1000  (Ethernet)
        RX packets 27322  bytes 32091963 (30.6 MiB)
        RX errors 0  dropped 9  overruns 0  frame 0
        TX packets 17321  bytes 2397304 (2.2 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536
        inet 127.0.0.1  netmask 255.0.0.0
        inet6 ::1  prefixlen 128  scopeid 0x10<host>
        loop  txqueuelen 1000  (Local Loopback)
        RX packets 2923  bytes 1391109 (1.3 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 2923  bytes 1391109 (1.3 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

wlp3s0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        ether bc:f1:71:6b:56:b1  txqueuelen 1000  (Ethernet)
        RX packets 14800  bytes 1995679 (1.9 MiB)
        RX errors 0  dropped 0  overruns 0  frame 0
        TX packets 11423  bytes 29069791 (27.7 MiB)
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
```

此输出表示有个 `br0` 的接口处于工作状态，而机器有线网卡 `enp2s0` 处于 `UP` 状态，但没有 IP 地址。接下来 `hostapd` 将用到这个 `br0` 接口。


## `hostapd` 配置

`hostapd` 是个服务，其配置文件为 `/etc/hostapd/hostapd.conf`。编辑该配置文件内容如下。


```conf
interface=wlp3s0
bridge=br0

# 要在 IEEE 802.11 管理框架中使用的 SSID（即热点名）
ssid=YourOwnSSID
# 驱动接口类型（hostap/wired/none/nl80211/bsd）
driver=nl80211
# 国家或地区代码（ISO/IEC 3166-1）
country_code=US

# 工作模式 (a = IEEE 802.11a (5 GHz), b = IEEE 802.11b (2.4 GHz)
hw_mode=g
# 使用信道
channel=7
# 允许最大连接数
max_num_sta=5

# Bit 字段：bit0 = WPA, bit1 = WPA2
wpa=2
# Bit 字段：1=wpa, 2=wep, 3=both
auth_algs=1

# 加密协议；禁用不安全的 TKIP
wpa_pairwise=CCMP
# 加密算法
wpa_key_mgmt=WPA-PSK
wpa_passphrase=YourOwnSecret

# hostapd日志设置
logger_stdout=-1
logger_stdout_level=2

# 802.11n设备请取消注释并修改以下部分
## 启用802.11n支持
#ieee80211n=1
## QoS 支持
#wmm_enabled=1
## 请使用“iw list”查看设备信息并相应地修改 ht_capab
#ht_capab=[HT40+][SHORT-GI-40][TX-STBC][RX-STBC1][DSSS_CCK-40]
```

注意，其中的 `interface` 为支持 AP 模式的无线网卡，`bridge` 为前面建立的桥接接口 `br0`。保存配置后，运行 `$ sudo systemctl enable --now hostapd` 启用这个服务，就实现了无线访问点的宽带共享。`$ sudo systemctl status hostapd` 命令可以用来查看 `hostapd` 服务的状态。

## 注意事项

1. 若执行 `nmcli con mod bridge-br0 connection.autoconnect true` 及 `nmcli con mod bridge-slave-enp2s0 connection.autoconnect true` 命令，而意图自动开启 `bridge-br0` 与 `bridge-slave-enp2s0` 两个连接，则不光达不到目的，还会导致运行 `nmcli conn up bridge-br0` 及 `nmcli conn up bridge-slave-enp2s0` 两个命令报错。

2. Intel AX200 在没有数据时会进入睡眠状态，此问题仍需考虑如何解决。尝试在文件 `/etc/modprobe.d/iwlwifi.conf` 中添加：

```conf
options iwlmvm power_scheme=1
```

或者运行命令 `$ sudo iw dev wlp3s0 set power_save off`，不知效果如何。
