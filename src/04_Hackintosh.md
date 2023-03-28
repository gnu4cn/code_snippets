# Hackint0sh

在非苹果硬件上安装 MacOS。

借助 Clover引导器，理论上都可以安装MacOS。对于就的硬件，Clover还可虚拟出新的EFI接口，以供安装新版本的Linux发行版。

`BIOS -> Clover -> MacOS/Linux`

在非苹果硬件上安装MacOS的难点在于 Clover的配置。

1. `$sudo efibootmgr`与 `$ sudo efibootmgr -b 00xx -B` 可以查看EFI启动项与删除启动项。

2. `reFind` 可以找到所有EFI启动项.
