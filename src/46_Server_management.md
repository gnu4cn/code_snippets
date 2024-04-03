# 服务器管理


本文记录服务器管理方面的一些经验。




## H330 阵列卡 HBA 直通模式与 RAID 模式切换

    HBA 模式须在 iDrac 中切换，在 UEFI 界面不会生效。

## 启动 iDrac 虚拟控制台
    启动虚拟控制台有 Java 和 HTML5 两种方式。其中 Java 方式会下载一个 `.jnlp` 文件，需要 JRE 环境，且在运行这个 `.jnlp` 文件时，会出现签名问题而无法启动。因此需要选择 HTML5 方式启动虚拟控制台。

    需要注意的是，iDrac 所使用网口 NIC 选项中，有 `Dedicated/LOM1/LOM2/LOM3/LOM4`，应选择的是 `Dedicated`。


## DELL 存储开机关机顺序


    开机：打开 “扩展柜” 电源 -> 等待 5 分钟后，打开 “控制器” 电源 -> 等待 5 分钟后，打开 “服务器” 电源
    关机：“服务器” 关机 -> 等待 5 分钟后，“控制器（通过 Storage Manager 执行关机）” -> 等待 5 分钟后，关闭 “扩展柜” 电源


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
