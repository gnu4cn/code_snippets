# modprobe

> 随着 UEFI BIOS 的广泛使用，操作系统内核模块的加载，在BIOS 中开启了 “Secure Boot”选项后，就更加严格了。没有数字签名/内核认证的模块，是无法加载的。会出现没有权限报错，通过 “dmesg” 可以看到更多信息。

近期由于旧笔记本不支持5gHz WiFi网络，故采购一个USB的双频无线网卡（`Bus 003 Device 003: ID 0bda:c811 Realtek Semiconductor Corp. 802.11ac NIC`），这个无线网卡没有内核支持。需编译安装`dkms`的内核模块。驱动在 [这里](https://github.com/brektrou/rtl8821CU.git)。

参考项目的 `README.md` 文件即可安装上，且支持热插拔。

但是笔记本内置的 PCI 无线网卡就显得多余了。此时可将原来的`ath9k`内核驱动模块加以屏蔽。

`sudo vim.gtk3 /etc/modprobe.d/blacklist.conf`

将 

`blacklist ath9k` 

加入到该文件中，并运行

`sudo update-initramfs -u`


`sudo modprobe -r ath9k`

就可以去掉原有的 `ath9k` 无线网卡，只保留一个新的 USB 双频无线网卡。
