# 使用华为的Repos

在运维工作中，需要使用各种镜像，这里进行汇总。

## 00. PyPI 使用华为镜像


`pip` 的配置文件位置：


- `/etc/pip.conf`

- `~/.pip/pip.conf`

- `~/.config/pip/pip.conf`


```bash
mkdir ~/.pip
vim.gtks ~/.pip/pip.conf
```

加入以下内容：

```conf
[global]
index-url = https://repo.huaweicloud.com/repository/pypi/simple
trusted-host = repo.huaweicloud.com
timeout = 120
```

Python3 `venv` 环境下使用华为镜像（参考：[python venv pip使用国内源](https://blog.csdn.net/duoyasong5907/article/details/129190001)）：


- 首先激活 `venv` 环境，`source .venv/bin/activate`;

- 然后配置 `pip` 使用国内源，随后的下载就都会使用国内源了。

```console
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

> **注意**：此命令修改的是 `~/.config/pip/pip.conf`。

亦可以安装 `pypi` 软件包 `pipyyuan`，一键修改国内源：`https://pypi.org/project/pipyuan/`。




## 01. NVM 配置华为镜像

```bash
echo 'export NVM_NODEJS_ORG_MIRROR=https://repo.huaweicloud.com/nodejs' >> ~/.bashrc
```

> **注意**：上面的配置似乎已经不可用。下面是 阿里云 的镜像配置。


```bash
echo 'export NVM_NODEJS_ORG_MIRROR="https://npmmirror.com/mirrors/node"' >> ~/.bashrc
```


然后运行：

```bash
npm config set registry https://repo.huaweicloud.com/repository/npm/
npm cache clean -f
npm config set disturl https://repo.huaweicloud.com/nodejs
npm config set sass_binary_site https://repo.huaweicloud.com/node-sass
npm config set phantomjs_cdnurl https://repo.huaweicloud.com/phantomjs
npm config set chromedriver_cdnurl https://repo.huaweicloud.com/chromedriver
npm config set operadriver_cdnurl https://repo.huaweicloud.com/operadriver
npm config set electron_mirror https://repo.huaweicloud.com/electron/
npm config set python_mirror https://repo.huaweicloud.com/python
```


### 构建Electron 应用时配置及问题


- 配置 `npm` 与 `yarn` 镜像源。


```bash

# ==========================================================
# NPM
# ==========================================================

npm set registry https://registry.npmmirror.com # 注册模块镜像
npm set disturl https://npmmirror.com/mirrors/node # node-gyp 编译依赖的 node 源码镜像

## 以下选择添加
npm set sass_binary_site https://registry.npmmirror.com/mirrors/node-sass # node-sass 二进制包镜像
npm set electron_mirror https://registry.npmmirror.com/mirrors/electron/ # electron 二进制包镜像
npm set puppeteer_download_host https://registry.npmmirror.com/mirrors # puppeteer 二进制包镜像
npm set chromedriver_cdnurl https://registry.npmmirror.com/mirrors/chromedriver # chromedriver 二进制包镜像
npm set operadriver_cdnurl https://registry.npmmirror.com/mirrors/operadriver # operadriver 二进制包镜像
npm set phantomjs_cdnurl https://registry.npmmirror.com/mirrors/phantomjs # phantomjs 二进制包镜像
npm set selenium_cdnurl https://registry.npmmirror.com/mirrors/selenium # selenium 二进制包镜像
npm set node_inspector_cdnurl https://registry.npmmirror.com/mirrors/node-inspector # node-inspector 二进制包镜像
npm set sentrycli_cdnurl https://npmmirror.com/mirrors/sentry-cli/ # sentry-cli

npm cache clean --force # 清空缓存

# ==========================================================
# YARN
# ==========================================================

yarn config set registry https://registry.npmmirror.com # 注册模块镜像
yarn config set disturl https://npmmirror.com/mirrors/node # node-gyp 编译依赖的 node 源码镜像

## 以下选择添加
yarn config set sass_binary_site https://registry.npmmirror.com/mirrors/node-sass # node-sass 二进制包镜像
yarn config set electron_mirror https://registry.npmmirror.com/mirrors/electron/ # electron 二进制包镜像
yarn config set puppeteer_download_host https://registry.npmmirror.com/mirrors # puppeteer 二进制包镜像
yarn config set chromedriver_cdnurl https://registry.npmmirror.com/mirrors/chromedriver # chromedriver 二进制包镜像
yarn config set operadriver_cdnurl https://registry.npmmirror.com/mirrors/operadriver # operadriver 二进制包镜像
yarn config set phantomjs_cdnurl https://registry.npmmirror.com/mirrors/phantomjs # phantomjs 二进制包镜像
yarn config set selenium_cdnurl https://registry.npmmirror.com/mirrors/selenium # selenium 二进制包镜像
yarn config set node_inspector_cdnurl https://registry.npmmirror.com/mirrors/node-inspector # node-inspector 二进制包镜像
yarn config set sentrycli_cdnurl https://npmmirror.com/mirrors/sentry-cli/ # sentry-cli

yarn cache clean # 清空缓存
```


- `Generated checksum for "electron-vxx.y.zz-win32-x64.zip" did not match expected checksum.` 问题

在 WSL/Debian 中，修改 Windows 主目录下的 `.npmrc` 文件，加入以下内容。


```bash
➜  Hector PENG pwd
/mnt/c/Users/Hector PENG
➜  Hector PENG cat .npmrc
registry=https://registry.npmmirror.com
ELECTRON_MIRROR=https://npmmirror.com/mirrors/electron/
ELECTRON_BUILDER_BINARIES_MIRROR=https://npmmirror.com/mirrors/electron-builder-binaries/
```

> **参考**
>
> - [设置 npm 和 yarn 的镜像源为淘宝镜像源](https://gist.github.com/lvxianchao/2dcba1a93422037273dd41a924ddaab9)
>
> - [安装指导](https://www.electronjs.org/zh/docs/latest/tutorial/installation#%E9%95%9C%E5%83%8F)
>
> - [`npm` 和 `yarn` 包管理器报错](https://blog.csdn.net/m0_52108067/article/details/127911300)


## 02. MAVEN 配置华为镜像

修改 `~/.mvn/settings.xml`, 在`<mirrors></mirrors>`里加入以下内容：

```xml
<mirror>
    <id>huaweicloud</id>
    <mirrorOf>*</mirrorOf>
    <url>https://repo.huaweicloud.com/repository/maven/</url>
</mirror>
```

**也可以直接下载 `settings.xml` 文件**

> Apache Maven 的安装：

> `$sudo tar xf apache-maven-3.x.x-bin.tar.gz -C /opt/`
> `$sudo ln -s /opt/apache-maven-3.x.x /opt/mvn`

> 建立 `/etc/profile.d/mvn.sh`，加入如下内容：

```bash
export JAVA_HOME=/opt/jdk
export M2_HOME=/opt/mvn
export MAVEN_HOME=/opt/mvn
export PATH=${M2_HOME}/bin:${PATH}
```

> * 注意 *：`/opt/jdk` 也是到 `/opt/jdk-xx.x.x` 目录的符号链接。

> 运行 `$sudo chmod +x /etc/profile.d/mvn.sh`


## RubyGems



Ruby语言的开源依赖包镜像库。

使用说明 打开终端并执行如下命令：

```console
gem sources --add https://repo.huaweicloud.com/repository/rubygems/ --remove https://rubygems.org/
```

如果你使用 Gemfile 和 Bundler，你可以用 Bundler 的 Gem 源代码镜像命令

```console
bundle config mirror.https://rubygems.org https://repo.huaweicloud.com/repository/rubygems/
```

