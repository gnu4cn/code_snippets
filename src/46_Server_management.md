# 服务器管理

- H330 阵列卡 HBA 直通模式与 RAID 模式切换

    HBA 模式须在 iDrac 中切换，在 UEFI 界面不会生效。

- 启动 iDrac 虚拟控制台
    启动虚拟控制台有 Java 和 HTML5 两种方式。其中 Java 方式会下载一个 `.jnlp` 文件，需要 JRE 环境，且在运行这个 `.jnlp` 文件时，会出现签名问题而无法启动。因此需要选择 HTML5 方式启动虚拟控制台。

    需要注意的是，iDrac 所使用网口 NIC 选项中，有 `Dedicated/LOM1/LOM2/LOM3/LOM4`，应选择的是 `Dedicated`。


- DELL 存储开机关机顺序


    开机：“扩展柜” -> “控制器” -> “服务器”
    关机：“服务器” -> “控制器” -> “扩展柜”
