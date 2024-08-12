# 内容管理系统部署笔记


开源、优秀的内容管理系统繁多，有的只有框架没有 UI，有的架构过于复杂，真正能开箱即用很少。下面是在部署一个运行在企业内部办公网 Portal 页面时，对各种 CMS 部署的笔记（最后选择了 Typo3）。


## Typo3 CMS 安装笔记


### 需要安装 `php-ldap`


```console
composer req causal/ig_ldap_sso_auth
```


安装 Typo3 的 `LDAP/SSO` 认证扩展，需要安装 `php-ldap` 包。



```console
apt install -y php-ldap
```


## Publify 安装笔记

[Publify](https://github.com/publify/publify) 是以 Ruby 语言编写的优秀 CMS 系统。


### `gem` 检索远端上包版本


```console
gem list ^rails$ --remote --all
```


### `gem` 安装 Ruby 包


```console
gem install nokogiri -v 1.15.6
gem install rails --version 5.2.8.1
```


### 更新 RubyGems 到指定版本


```console
gem update --system 3.3.22
```


### 安装 Publify 


```console
RAILS_ENV=production bundle install --without development test mysql sqlite
rake db:migrate
rake db:seed
rake assets:precompile
```

> **注意**：上面是已经使用 PostgreSQL 并已经建立了数据库 `publify` 的情况下。


> **参考链接**
>
> - [How to Install Publify on Kali Linux Latest](https://ipv6.rs/tutorial/Kali_Linux_Latest/Publify/)
>
> - [Install Ruby 2.7.5 on Debian Bookworm](https://text.malam.or.id/2024/05/06/install-ruby-2.7.5-on-debian-bookworm/)
>
> - [rbenv-cn](https://github.com/RubyMetric/rbenv-cn)
>
> - [Update RubyGems to a specific version (for legacy system installs)](https://gist.github.com/larsthegeek/4029012)
>
> - [Install Publify on Ubuntu 14.04](https://www.rosehosting.com/blog/install-publify-on-an-ubuntu-14-04/)

## Superdesk 安装笔记


Superdesk 有较多依赖。需要在编译构建时，安装以下软件包。


```console
apt install -y libbz2-dev zlib1g-dev
```

然后编译安装 Python-3.8。


```console
./configure --prefix=/opt/python38 --enable-optimizations --with-ssl --with-readline
make -j$(nproc)
sudo make install
```

然后安装 Python-3.8 的一些模组。


```console
cd /opt/python38/bin
python3 -m pip3 install -U pip3
./pip3 install Click requests pyexiv2
```

### 前端


需要降级 NODEJS 到 14 lts 版本，以得到前端匹配的 `npm` 版本。

并需要将 `package-lock.json` 中的 `registry.nodejs.org` 更换为 `repo.huaweicloud.com/repository/npm`，以加快下载速度。 

此外，前端构建需要使用 Python2，因此需要安装 Python27。


参考：

- [【环境篇 npm 报错】npm ERR gyp ERR stack `import sys； print “%s.%s.%s“ % sys.version_info[:3]；`](https://blog.csdn.net/weixin_49736959/article/details/122149324)

- [Installing Python 2.7 on Debian 12 (Bookworm)](https://www.fadedbee.com/2024/01/18/installing-python2-on-debian-12-bookworm/)

## Plone 安装笔记


在使用 [plone/Installers-UnifiedInstaller](https://github.com/plone/Installers-UnifiedInstaller) 安装 [Plone](https://plone.org) 有诸多要求、依赖。这里加以记录。


### `libffi-dev`、`libjpeg-dev`、`libxslt1-dev` 与 `libxslt1.1`

这是系统的 foreign function library，外部函数库的开发链接库（头文件和链接库），在后面 `pip install python-ldap` 过程中，构建出 `ldap` 的 Python 封装时，要用到 Python 的 `_ctypes` 模块，而这个模块就需要在编译 Python 时，预先安装 `libffi-dev` 这个包。

`libjpeg-dev`、`libxslt1-dev` 与 `libxslt1.1` 是运行 UnifiedInstaller 时需要的依赖。


```console
sudo apt install -y libffi-dev libjpeg-dev libxslt1-dev libxslt1.1
```


### 编译 `ssl`、`readline` 支持（Debian Bookworm）


，要求 Python 必须有对 `ssl` 的支持，最好带有 `readline` 的支持。为此需要在编译 Python38 时，带有对他们两的支持。

```console
sudo apt install libssl-dev libreadline-dev -y
./configure --prefix=/opt/python38 --enable-optimizations --with-ssl --with-readline
make -j$(nproc)
sudo make install
```


### 为 `buildout` 设置 PyPi 镜像

默认运行 `buildout`，会使用 `pypi.org` 并从 `files.pythonhosted.org` 下载 Python 包，这样速度会很慢且有下载失败问题。为此需要为 `buildout` 配置 PyPi 镜像。修改 `base.cfg` 文件，在 `[buildout]` 小节后加入 `index=https://repo.huaweicloud.com/repository/pypi/simple`。

```cfg
[buildout]
index=https://repo.huaweicloud.com/repository/pypi/simple
eggs-directory=../buildout-cache/eggs
download-cache=../buildout-cache/downloads
abi-tag-eggs = true
```


### UnifiedInstaller 的 `buildout.cfg`

UnifiedInstaller 位于 `buildout_templates/buildout.cfg`，需要在 `eggs` 中添加如下内容。


```cfg
eggs =
    Plone
    Pillow
    Products.PluginRegistry
    Products.PluggableAuthService
    Products.LDAPUserFolder
    Products.SimpleUserFolder
    Products.LDAPMultiPlugins
    Products.PloneLDAP
```


### `Zope` 依赖问题

`buildout_templates/buildout.cfg` 里，`[buildout]` 小节的 `extends` 中引用的 `versions.cfg`，使用的是 `4.8.10` 版本的 `Zope`，由于上面添加的一些 `eggs` 需要 `Zope>=5`，会导致安装失败，报出以下错误。

```console
Error: The requirement ('Zope>=5') is not allowed by your [versions] constraint (4.8.10)
Buildout failed. Unable to continue
```

此时只需在 `[buildout]` 小节的 `extends` 中，添加如下 `Zope` 的 `versions.cfg` 即可解决此问题。如下所示。

```cfg
extends =
    base.cfg
    https://dist.plone.org/release/5.2.14/versions.cfg
    https://zopefoundation.github.io/Zope/releases/5.10/versions.cfg
```

> 参考：
> - [plone 的部署 以及采用windows AD认证](https://blog.51cto.com/wsxxsl/1921347)
> - [Delivering egg-based applications with zc.buildout, using a distributed model (Tarek Ziadé)](https://markvanlent.dev/2008/10/10/delivering-egg-based-applications-with-zc.buildout-using-a-distributed-model-tarek-ziade/)







## 参考


> - [Some of our services: CMS & portal systems.](https://system4all.de/en/cms-portal-systems/)
