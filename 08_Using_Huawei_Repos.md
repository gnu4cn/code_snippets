# 使用华为的Repos

在运维工作中，需要使用各种镜像，这里进行汇总。

## 00. PyPI 使用华为镜像

```bash
$mkdir ~/.pip
$vim.gtks ~/.pip/conf
```

加入以下内容：

```conf
[global]
index-url = https://repo.huaweicloud.com/repository/pypi/simple
trusted-host = repo.huaweicloud.com
timeout = 120
```

## 01. NVM 配置华为镜像

```bash
$echo 'export NVM_NODEJS_ORG_MIRROR=https://repo.huaweicloud.com/nodejs' >> ~/.bashrc
```

然后运行：

```bash
$npm config set registry https://repo.huaweicloud.com/repository/npm/
$npm cache clean -f
$npm config set disturl https://repo.huaweicloud.com/nodejs
$npm config set sass_binary_site https://repo.huaweicloud.com/node-sass
$npm config set phantomjs_cdnurl https://repo.huaweicloud.com/phantomjs
$npm config set chromedriver_cdnurl https://repo.huaweicloud.com/chromedriver
$npm config set operadriver_cdnurl https://repo.huaweicloud.com/operadriver
$npm config set electron_mirror https://repo.huaweicloud.com/electron/
$npm config set python_mirror https://repo.huaweicloud.com/python 
```


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
