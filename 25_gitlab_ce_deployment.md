# GitLab CE 部署笔记

## 安装

这里记录在 CentOS 7 上，安装部署 GitLab CE 的步骤。

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


## 数据库与代码仓库得备份


- 修改 `/etc/gitlab/gitlab.rb` 中的：

```ruby
gitlab_rails['backup_path'] = "/backup"
```

> **注**：这里的 `/backup` 是经由 `/etc/fstab` 挂载到系统的 NFS 存储空间

> 其所有者为 `git:root`，权限为 `755`

