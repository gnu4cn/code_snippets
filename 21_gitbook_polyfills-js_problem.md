# Gitbook 安装时报错问题

`gitbook-cli` 安装时报错：

```console
.../polyfills.js
TypeError: cb.apply is not a function
```

问题，参考：[Gitbook-cli install error TypeError: cb.apply is not a function inside graceful-fs](https://stackoverflow.com/questions/64211386/gitbook-cli-install-error-typeerror-cb-apply-is-not-a-function-inside-graceful)

应在 `gitbook-cli` 包目录下安装最新版的 `graceful-fs`：

```console
cd ~/.nvm/versions/node/v12.22.12/lib/node_modules/gitbook-cli/node_modules/npm/node_modules/
npm i graceful@latest --save
```

安装完成后问题消失。
