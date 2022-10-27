# 关于 GitLab 的备份问题（包括备份到挂载的NFS分区）


- 修改 `/etc/gitlab/gitlab.rb` 中的：

```ruby
gitlab_rails['backup_path'] = "/backup"
```

***注**：这里的 `/backup` 是经由 `/etc/fstab` 挂载到系统的 NFS 存储空间*


