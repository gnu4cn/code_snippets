# 服务器管理


本文记录服务器管理方面的一些经验。



## 恢复 `rm -rf` 删除的数据


出现此类事故后，应立即关机。使用 GParted LiveCD 启动系统，`sudo su -` 后运行 `fdisk -l`，找到要恢复的磁盘设备。然后给 GParted 配置 IP 地址和 DNS 服务器。运行 `apt install -y extundelete` 安装 `extundelete`。然后直接运行 `extundelete /dev/mapper/vg_vol01-home –restore-all`，恢复 `home` 卷下的数据（应先 `cd` 到挂载的 NFS 目录）。


参考：

- [干货：“ rm -rf” 克星ext4magic](https://www.modb.pro/db/25652)

- [linux rm -rf * 文件恢复记](https://www.cnblogs.com/fps2tao/p/8676463.html)


## H330 阵列卡 HBA 直通模式与 RAID 模式切换


HBA 模式须在 iDrac 中切换，在 UEFI 界面不会生效。

## 启动 iDrac 虚拟控制台


启动虚拟控制台有 Java 和 HTML5 两种方式。其中 Java 方式会下载一个 `.jnlp` 文件，需要 JRE 环境，且在运行这个 `.jnlp` 文件时，会出现签名问题而无法启动。因此需要选择 HTML5 方式启动虚拟控制台。

需要注意的是，iDrac 所使用网口 NIC 选项中，有 `Dedicated/LOM1/LOM2/LOM3/LOM4`，应选择的是 `Dedicated`。


## DELL 存储开机关机顺序

  
- 开机：打开 “扩展柜” 电源 -> 等待 5 分钟后，打开 “控制器” 电源 -> 等待 5 分钟后，打开 “服务器” 电源

- 关机：“服务器” 关机 -> 等待 5 分钟后，“控制器（通过 Storage Manager 执行关机）” -> 等待 5 分钟后，关闭 “扩展柜” 电源


## DELL ME5 多路径配置


在 Debian 12(Bookworm) 下，配置对 DELL ME5 的多路径（multipath）会很快。包含以下步骤。


- 安装 `multipath-tools` 软件包；

- 重启机器。然后运行 `multipath -l` 或 `multipath -v3`，根据 DM 多路径下的配置，列出 Dell PowerVault ME5 系列存储设备。


```console
...
===== paths list =====
uuid                              hcil    dev dev_t pri dm_st chk_st vend/prod/rev        dev_st
362cea7f05d1d84002d953761a24b9173 0:2:0:0 sdb 8:16  1   undef undef  DELL,PERC H740P Mini unknown
3600c0ff00065bf8774a1056601000000 1:0:0:0 sda 8:0   10  undef undef  DellEMC,ME5          unknown
3600c0ff00065bf8774a1056601000000 1:0:1:0 sdc 8:32  50  undef undef  DellEMC,ME5          unknown
```

注意其中的 `3600c0ff00065bf8774a1056601000000`，其中两个路径的 uuid 是一致的。


- 修改配置文件 `/etc/multipath.conf`，该文件是 `multipathd` 服务的配置文件；

```console
root@backup:~# cat /etc/multipath.conf
defaults {                                                                                                               find_multipaths yes
        user_friendly_names yes
}

blacklist {
}

devices {
        device {
                vendor "DellEMC"
                product "ME5"
                path_grouping_policy "group_by_prio"
                path_checker "tur"
                hardware_handler "1 alua"
                prio "alua"
                failback immediate
                rr_weight "uniform"
                path_selector "service-time 0"
        }
}
multipaths {
        multipath {
                wwid "3600c0ff00065bf8774a1056601000000"
                alias me5_vol01_20t
        }
}
```

- 重启服务：`systemctl restart multipathd`；随后运行 `fdisk -l`，有以下输出。


```console
root@backup:~# fdisk -l
Disk /dev/sdc: 18.19 TiB, 19999997558784 bytes, 39062495232 sectors
Disk model: ME5
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 1048576 bytes


Disk /dev/sda: 18.19 TiB, 19999997558784 bytes, 39062495232 sectors
Disk model: ME5
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 1048576 bytes


Disk /dev/sdb: 7.28 TiB, 7999376588800 bytes, 15623782400 sectors
Disk model: PERC H740P Mini
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 262144 bytes / 1048576 bytes
Disklabel type: gpt
Disk identifier: BF366EEC-4128-4E6B-80D2-7EDC93E00A4B

Device        Start         End     Sectors  Size Type
/dev/sdb1      2048      999423      997376  487M Linux filesystem
/dev/sdb2    999424     1499135      499712  244M EFI System
/dev/sdb3   1499136    17123327    15624192  7.5G Linux swap
/dev/sdb4  17123328 15623780351 15606657024  7.3T Linux filesystem


Disk /dev/mapper/me5_vol01_20t: 18.19 TiB, 19999997558784 bytes, 39062495232 sectors
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 4096 bytes
I/O size (minimum/optimal): 4096 bytes / 1048576 bytes
```

- 可以看到 `Disk /dev/mapper/me5_vol01_20t: 18.19 TiB, 19999997558784 bytes, 39062495232 sectors` 已经出现，随后即可使用磁盘工具对其格式化并加以使用。



### Debian 下格式化多路径的块设备


经由 `multipathd` 建立的多路径下的块设备，比如 `/dev/mapper/me5_vol01_20ti`，在使用命令 `sudo gparted /dev/mapper/me5_vol01_20ti`，欲对其进行分区格式化创建文件系统以加以利用时，发现总是会报出 `Device or resource busy` 错误。

有人的解决办法，是暂时移除多路径设备的映射。步骤如下：


- 移除多路径设备名字。（`multipath -f /dev/mappper/me5_vol01_20ti`）;

- 对多路径从设备运行 `gparted`。（如：`sudo gparted /dev/sdb`）;

- 重建多路径设备映射。（`multipath -r`）。


**注意**：在移除多路径设备时，若多路径设备已被挂载，那么会报出以下错误：


```console
root@backup:~# multipath -f /dev/mapper/me5_vol01_20t
59172.163246 | me5_vol01_20t-part1: map in use
```

在排除了对该多路径设备的已有挂载后，移除多路径设备的命令将不再报错。


参考：

- [mke2fs says "Device or resource busy while setting up superblock"](https://serverfault.com/a/727244/994825)

- [Multipath: Best and Safe Solution Map in Use Devices](https://www.teimouri.net/remove-multipath-device/)


## `btrfs` 分区的挂载


临时挂载 `btrfs` 分区，直接运行命令 `sudo mount /dev/mapper/me5_vol01_20ti-part1 /0.135`，即可把 `/dev/mapper/me5_vol01_20ti-part1` 挂载到主机的 `/0.135` 目录下。

要将此挂载设置，写入到 `/etc/fstab`，就需要先找到 `btrfs` 设备的信息，通过以下方式之一：


```console
# btrfs filesystem show /mount/point/
# btrfs filesystem show /dev/DEVICE
# btrfs filesystem show /dev/sda
# btrfs filesystem show
```

比如：


```console
root@backup:~# btrfs filesystem show
Label: none  uuid: e508b096-1641-41aa-96f4-37548f6e33dd
        Total devices 1 FS bytes used 24.56GiB
        devid    1 size 7.27TiB used 45.02GiB path /dev/sdd4

Label: none  uuid: ca060281-526e-4a88-b9f5-296a32624c9b
        Total devices 1 FS bytes used 78.37MiB
        devid    1 size 487.00MiB used 216.00MiB path /dev/sdd1

Label: none  uuid: 8447d73b-fd92-4ee1-9769-af1961ceb79c
        Total devices 1 FS bytes used 144.00KiB
        devid    1 size 195.31GiB used 2.02GiB path /dev/mapper/me5_vol01_20t-part1

```


### `mount` 命令语法


```console
root@backup:~# mkdir /data/
root@backup:~# mount /dev/mapper/me5_vol01_20t-part1 /data
root@backup:~# btrfs filesystem df /data
Data, single: total=8.00MiB, used=0.00B
System, DUP: total=8.00MiB, used=16.00KiB
Metadata, DUP: total=1.00GiB, used=128.00KiB
GlobalReserve, single: total=3.50MiB, used=0.00B
```


### `/etc/fstab` 文件语法


首先要找出设备的 UUID，请输入：


```console
# blkid /dev/mapper/me5_vol01_20t-part1
```

或

```console
# lsblk --fs /dev/mapper/me5_vol01_20t-part1
```

将输出：

```console
root@backup:~# blkid /dev/mapper/me5_vol01_20t-part1
/dev/mapper/me5_vol01_20t-part1: UUID="8447d73b-fd92-4ee1-9769-af1961ceb79c" UUID_SUB="04798ed7-4ad0-4ea2-b2e1-154fae497871" BLOCK_SIZE="4096" TYPE="btrfs" PARTUUID="2cd4eb20-779e-4c8c-9d73-82280115407e"
```


```console
root@backup:~# lsblk --fs /dev/mapper/me5_vol01_20t-part1
NAME                FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
me5_vol01_20t-part1 btrfs              8447d73b-fd92-4ee1-9769-af1961ceb79c
root@backup:~# lsblk --fs /dev/mapper/me5_vol01_20t-part2
NAME                FSTYPE FSVER LABEL UUID                                 FSAVAIL FSUSE% MOUNTPOINTS
me5_vol01_20t-part2 btrfs              34d15471-e8b1-401e-94cd-f4465e6ad4ba
```

然后编辑 `/etc/fstab`，下面的语法，是使用 UUID 把 `btrfs` 设备挂载于 `/0.135` 和 `/me5_vol01_part2` 两个挂载点：


```fstab
UUID=8447d73b-fd92-4ee1-9769-af1961ceb79c /0.135           btrfs   defaults        0       0
UUID=34d15471-e8b1-401e-94cd-f4465e6ad4ba /me5_vol01_part2          btrfs   defaults        0       0
```


## 存储文件数量限制导致可用空间为 0


运行 `df -i`，可以看到 `IUse%` 为 `100%`。此时即使存储还有可用空间，程序仍会报出可用空间为 `0`。解决方法：调整存储的文件数量限制。以 NetApp 为例：


```console
FAS2750::> voloume modify -vserver svm_data -volume tempdata -files 200000000
```

随后运行 `df -i`，将显示挂载的存储卷 `IUse%` 已降至低于 `100%`。

`df -i` 的示例输出：


```console
% df  -i
Filesystem      Inodes  IUsed   IFree IUse% Mounted on
tmpfs           122560    624  121936    1% /run                                                                                                                                     /dev/sda       1605632 289295 1316337   19% /
tmpfs           122560      1  122559    1% /dev/shm
tmpfs           122560      3  122557    1% /run/lock
tmpfs            24512     25   24487    1% /run/user/1000
```


## 数据备份


```bash
#!/usr/bin/env bash

declare -A backup_dir
backup_dir["analog_project"]="/opt"
backup_dir["analog_project/SOS_DATA/repo/analog_project.rep"]="/opt"
backup_dir["analog_project/SOS_DATA/cache/analog_project.cac"]="/opt"

do_backup() {
    if [ ! -d "${2}" ]; then mkdir -p "${2}"; fi
    if [ -d "${1}" ] && [ ! -z "$(ls -A ${1})" ] && [ $(ps -ef | grep "rsync" | grep "${3}" | wc -l) -eq 0 ]; then
        cd "${1}"
        /usr/bin/rsync -cdlptgo --delete --exclude ".snapshot" --exclude "tmp" . ${2}
        find . -maxdepth 1 -type d -not -name "." -not -name ".snapshot" -not -name "tmp" -not -name "SOS_DATA" -exec rsync -crulptgo --delete {} ${2} \;
    fi
}

for name in ${!backup_dir[@]}; do
    do_backup "/${name}" "${backup_dir[$name]}/${name}" $name
done
```

对于备份数据量大、文件数目多的数据，此备份脚本将其分解为较小的部分，以减小 `rsync` 所用到增量文件大小，有效提升备份速度。

参考：[如何使用 rsync 的高级用法进行大型备份](https://zhuanlan.zhihu.com/p/66206489)
