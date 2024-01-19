# InvenTree 部署笔记


若 `src/InvenTree/config.yaml` 中的 `database.PASSWORD` 配置，是个纯数字，那么就要用 `''` 或 `“""` 将其括起来，否则会报出错误：


```console
TypeError: quote_from_bytes() expected bytes
```

参考：[quote_from_bytes() expected bytes错误及其中一个原因](https://blog.csdn.net/weixin_45642669/article/details/126642640)
