# Python tips


本文记录 Python 的一些技巧、疑难现象。


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


## 在内网安装 Python 第三方包

参考：[如何在内网安装python第三方包（库）](https://blog.csdn.net/xue_11/article/details/112802149)


本文将采取参考链接中的第 3 种方法，批量安装 python 包。根据研发需求，要 `python 3.8.16` 环境，故首先安装 `python38` 包：`yay -S python38`，得到的 Python 版本为 `python 3.8.18`，与研发需求接近。然后运行 `mkdir temp && cd temp && python3.8 -m venv .venv`，建立 Python `venv` 环境。

然后，按照参考链接中的做法，首先：


- 在 `temp` 目录下的 `venv` 环境中，安装内网所需的 Python 包；

- 运行 `pip freeze --all > requirements.txt`，将这些所需的包，记录在 `requirements.txt` 文件中；

- 运行 `pip down -r requirements -d ~/packages_required/`，将这些所需包下载到 `~/packages_required/` 目录中；

- 将 `requirements.txt` 和 `packages_required` 文件夹，放在内网机器的同一文件夹下，执行 `pip install --no-index --find-links /path/to/packages_required -r requirements.txt`，就可以批量安装了。


**注意**：批量安装 `requirements.txt` 中的库时，建议将 `pip` 的安装包删掉，因为内网机器上以及有 `pip` 这个包了，删除时应将 `packages_required` 文件夹中的 `pip*.whl` 文件、`requirements.txt` 中 `pip` 这行删掉。



## `import git` 报出 `Segmentation fault`


![`import git` 报出 `Segmentation fault` 错误](images/import-git-segmentation-fault.png)

此问题较难发现、解决，耗时较长。期间发现 `import git` 疑似与 `GitPython` 相关，但实则是 `python-git` 所提供。

随后偶然发现在 `import pygit` 随后再 `import git` 时，就不报 `Segmentation fault` 错误了。且随后可以在 Python 程序中使用 `git` 这个模块了。


![`import git` 成功](images/import-git.png)


![使用导入的 `git` 模块](images/using-pygit.png)


## `import pandas` 报出 `segmentation fault`


Python 3.6.8 中，运行程序时，始终报出 `segmentation fault`。逐一排查，程序依赖 `pandas` 包，而 `pandas` 包又依赖 `numpy` 这个包。在环境中成功安装了 `numpy` 包后直接 `import numpy` 时，会报出 `segmentation fault`。


此问题并非个例，如：[Segmentation fault (core dumped) while trying to print numpy and pandas objects in python via cygwin](https://stackoverflow.com/questions/70511576/segmentation-fault-core-dumped-while-trying-to-print-numpy-and-pandas-objectshttps://stackoverflow.com/questions/70511576/segmentation-fault-core-dumped-while-trying-to-print-numpy-and-pandas-objects)。


但是，与上一个 `import git` 报 `segmentation fault` 类似，在 `import pandas`（或 `import numpy`）前，放一个 `import pip` 的行，就不会再报出 `segmentation fault` 错误。
