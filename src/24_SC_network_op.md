# 网优计划

本次网络优化，拟完成以下操作：

1. 将 TP-Link TC-SG1048 傻瓜交换机，更换为 Huawei S5735S-L48T4S 交换机；
2. 将所有 Trunk 口，都改为使用光口；
3. 在华为 VRP 统一认证模式下，配置 `dot1x` 和 `mac` 认证，对有线接入终端，根据机器中是否已有颁发的证书，及是否已将机器 MAC 地址加入到 AD 域账户，而将其相应地划分到 `Lab VLAN` 和 `Office VLAN`。


## 对现有网络连接拓扑的认识

根据前期对现有网络拓扑的调查和掌握，在经两台 Huawei S5720 堆叠后，而形成的核心交换机（`core-sw`）上，`GigaEth 0/0/1`、`GigaEth 0/0/2`、`GigaEth 1/0/1` 与 `GigaEth 1/0/2` 四个千兆口，组成 `eth-trunk 12`，连接到由两台 FortiGate 401E 堆叠而成的防火墙 `gw` 上。连接关系如下：

```console
S5720-1.GigaEth-1 <-> 401E-2.GigaEth-13
S5720-1.GigaEth-2 <-> 401E-1.GigaEth-15
S5720-2.GigaEth-1 <-> 401E-1.GigaEth-13
S5720-2.GigaEth-2 <-> 401E-1.GigaEth-14
```


`core-sw` 上的 `GigaEth 0/0/3`、`GigaEth 0/0/4`、`GigaEth 1/0/3` 与 `GigaEth 1/0/4` 四个接口，组成 `eth-trunk 34`，也连接到防火墙 `gw` 上。连接关系如下：

```console
S5720-1.GigaEth-3 <-> 401E-1.GigaEth-16
S5720-1.GigaEth-4 <-> 401E-2.GigaEth-16
S5720-2.GigaEth-3 <-> 401E-2.GigaEth-14
S5720-2.GigaEth-4 <-> 401E-2.GigaEth-15
```

> 注意：S5720-2（对应机架上靠下的那台 S5720），并未像 S5720-1 那样，分别与防火墙连接。


`core-sw` 上的 `XGigaEth 0/0/1` 与 `XGigaEth 1/0/1` 组成 `eth-trunk 1`，与推测由两台 Huawei CE6810-48S4Q-LI 全光交换机，堆叠而成的 `cluster-sw` 连接起来。连接关系如下：

```console
S5720-1.XGigaEth-1 <-> CE6810-48S4Q-LI-2.10/1G-47
S5720-2.XGigaEth-1 <-> CE6810-48S4Q-LI-1.10/1G-47
```

由于交换机堆叠的配置，不会写入到 `current-configuration` 配置文件，但可通过 `display stack` 等命令可以查看到。其中由两台 Huawei S5720 堆叠而成 `core-sw`，运行 `display stack` 的输出如下：

```console
$ display stack
Stack mode: Service-port
Stack topology type: Link
Stack system MAC: e000-846b-1072
MAC switch delay time: 10 min
Stack reserved VLAN: 4093
Slot of the active management port: --
Slot      Role        MAC Address      Priority   Device Type
-------------------------------------------------------------
0         Master      e000-846b-1072   150        S5720S-52X-LI-AC
1         Standby     e000-846b-106d   100        S5720S-52X-LI-AC
```


运行 `display stack configuration` 的输出如下：

```console
$ display stack configuration 
*    : Invalid-configuration
#    : Unsaved configuration
---------------Configuration on slot 0 Begin---------------
stack enable
stack slot 0 renumber 0
stack slot 0 priority 150
stack reserved-vlan 4093
stack timer mac-address switch-delay 10

interface stack-port 0/1
 port interface XGigabitEthernet0/0/3 enable
 port interface XGigabitEthernet0/0/4 enable

interface stack-port 0/2
---------------Configuration on slot 0 End-----------------

---------------Configuration on slot 1 Begin---------------
stack enable
stack slot 0 renumber 1
stack slot 1 priority 100
stack reserved-vlan 4093
stack timer mac-address switch-delay 10

interface stack-port 1/1

interface stack-port 1/2
 port interface XGigabitEthernet1/0/3 enable
 port interface XGigabitEthernet1/0/4 enable
---------------Configuration on slot 1 End-----------------
                                          
```


而对于另外两台 Huawei CE6810-48S4Q-LI 全光交换机的堆叠，推测应与这两台 S5720-52X-EI-AC 的堆叠类似，不同之处在于两台 CE6810-48S4Q-LI, 使用的是 `40GigaEth` 端口，和相应的连接介质，而非 S5720-52X-EI-AC 使用的 `XGigaEth` 端口和光纤连接。

## 将 `trunk` 口移到光口

在现有网络设备互联中，发现有以下设备直连到 `core-sw`:

1. 一台 Huawei CloudEngine S5735S-L24P4X-A PoE 交换机，通过其 `GigaEth 0/0/1` 连接到 `S5720-2.GiagEth-5`（对应 `core-sw GigaEth 1/0/5`）上；

2. 一台 Huawei CloudEngine S1730S-S48T4S-A 交换机，通过其 `GigaEth 0/0/1` 连接到 `S5720-2.GigaEth-6`（对应 `core-sw GigaEth 1/0/6`）上。

> 注意：这台 S1730S 所连接的 `core-sw GigaEth 1/0/6` 目前配置为 `access` 接口，而应当配置为 `trunk` 接口，并对这台 `S1730S` 交换机加以配置。
