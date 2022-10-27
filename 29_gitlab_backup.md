# 关于 GitLab 的备份问题（包括备份到挂载的NFS分区）

## 配置的备份

参考 [备份与恢复 Omnibus GitLab 的配置](https://docs.gitlab.com/omnibus/settings/backups.html)


- 修改 `/etc/gitlab/gitlab.rb` 中的：

```ruby
gitlab_rails['backup_path'] = "/backup"
```

> **注**：这里的 `/backup` 是经由 `/etc/fstab` 挂载到系统的 NFS 存储空间

> 其所有者为 `git:root`，权限为 `755`


