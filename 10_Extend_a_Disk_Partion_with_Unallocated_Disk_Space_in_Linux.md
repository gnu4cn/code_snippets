# Linux下利用未分配的磁盘空间来扩充磁盘分区

Linux系统磁盘分区不够用时，可通过利用未分配的磁盘空间，来扩充相应磁盘分区。操作步骤如下。

## 00. 使用 `cfdisk` 查看磁盘情况

```bash
$sudo cfdisk
```

![cfdisk命令的输出](images/cfdisk.png)

## 01. 修改分区表


