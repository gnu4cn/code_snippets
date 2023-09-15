# `git` 使用技巧

## 关于 `git tag`

+ 添加一个标签，并将其推送到远端

    - `git tag TAG_NAME`

    - `git tag TAG_NAME -a -m "message"`, 以给定的消息（而非提示输入），创建一个 “带注解的” 标签。

    - `git push origin TAG_NAME`

+ 删除本地及远端的标签

    - `git tag -d TAG_NAME`

    - `git push --delete origin TAG_NAME`

- 以提交日期顺序列出标签: `git tag --sort=committerdate`

