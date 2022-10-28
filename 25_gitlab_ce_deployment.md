# GitLab CE 部署笔记

## 安装

这里记录在 CentOS 7 上，安装部署 GitLab CE 的步骤。


> **注意**: 要开启 `80` 与 `443` 端口：

```console
# firewall-cmd --zone=public --add-service=http --permanent
# firewall-cmd --zone=public --add-service=https --permanent
```

1. 安装、更新 CentOS 7；

    - `sudo yum -y update`；
    - `sudo yum -y install bash-completion bash-completion-extras`

2. 参考 [Official Linux Package](https://about.gitlab.com/install/#centos-7) 安装 GitLab CE；

> **注意**：
>
> 列出软件包可用版本的命令：
> 
> `yum list gitlab-ce --showduplicates | sort -r`

在后面恢复 GitLab-CE 时，需严格按照备份时 gitlab-ce 的版本安装 GitLab-CE。

3. 配置相关证书；

- LDAP（M$ AD）导出的 PEM 证书，用于 GitLab CE 与 AD 服务器之间的秘密通信；

    ```console
    $ sudo cp gitlab-configs/certnew.pem /etc/pki/ca-trust/source/anchors/
    $ sudo update-ca-trust
    $ sudo cp gitlab-configs/certnew.pem /etc/gitlab/ssl/
    ```

- NGINX 的证书（要从根证书，生成 nginx web 主机（gitlab.xfoss.com）的证书）；

    ```console
    $ sudo cp gitlab-configs/gitlab.crt /etc/gitlab/ssl
    $ sudo cp gitlab-configs/gitlab-rsa.key /etc/gitlab/ssl
    ```


4. 拷贝 `gitlab.rb`，并编辑，然后执行 `$ sudo gitlab-cfg reconfigure` 重新配置。

    ```console
    $ sudo cp ~/gitlab-configs/gitlab.rb /etc/gitlab/
    $ sudo gitlab-cfg reconfigure
    ```

## 配置的备份

参考 [备份与恢复 Omnibus GitLab 的配置](https://docs.gitlab.com/omnibus/settings/backups.html)


```console
sudo gitlab-ctl backup-etc --backup-path <DIRECTORY>
```

将配置备份到指定位置。

编辑 root 用户的 cron 表，来创建一种定时的应用备份：

```console
$ sudo crontab -e -u root
```

```cron
15 04 * * 2-6  gitlab-ctl backup-etc && cd /etc/gitlab/config_backup && cp $(ls -t | head -n1) /secret/gitlab/backups/
```


## 数据库与代码仓库的备份


### 修改 `/etc/gitlab/gitlab.rb` 中的：

```ruby
gitlab_rails['backup_path'] = "/backup"
```

### 运行备份命令

```console
$ sudo gitlab-backup create

$ sudo gitlab-backup create INCREMENTAL=yes # 增量备份
```

> **注**：这里的 `/backup` 是经由 `/etc/fstab` 挂载到系统的 NFS 存储空间

> **注**：CentOS 7 中，需要安装安装 `yum install nfs-utils nfs-utils-lib`。

> 其所有者为 `git:root`，权限为 `755`


> **注意**：CentOS 7 上假设 NFS 服务器要开启 SeLinux 规则，并在防火墙上放行 NSF 服务：

```console
setsebool -P nfs_export_all_rw 1
setsebool -P nfs_export_all_ro 1


firewall-cmd --permanent --add-service=nfs
firewall-cmd --permanent --add-service=mountd
firewall-cmd --permanent --add-service=rpc-bind
firewall-cmd --reload
```

## 使用要点

### GitLab 命令行：Rails console

```console
$ sudo gitlab-rails console
```

### 数据库与代码仓库的恢复

```console
$ sudo gitlab-ctl stop puma
$ sudo gitlab-ctl stop sidekiq
# Verify
$ sudo gitlab-ctl status
$ sudo gitlab-backup restore BACKUP=11493107454_2018_04_25_10.6.4-ce
$ sudo gitlab-ctl reconfigure
$ sudo gitlab-ctl restart
$ sudo gitlab-rake gitlab:check SANITIZE=true
```
