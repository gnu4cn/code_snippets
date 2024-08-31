# 现代即时通讯方案 Matrix 部署笔记


本文记录 Matrix（`matrix-synapse`） 部署时的注意点。


## 一直同步的问题


若对 `homeserver.yaml` 中 `public_baseurl` 项目进行了不当配置，那么在用户登陆时将出现一直同步（“Syncing forever...”）问题。报出“If you've joined lots of rooms, this might take a while.” 提示。


**解决办法**：不配置 `public_baseurl`，或将其配置为正确的内容，比如 `https://matrix.xfoss.com:443`。
