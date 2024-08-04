# SVN 笔记


## 启动 `svnserve`

`snvserve -d -r /svn/repository/directory --listen-port 3690`

其中，`-d` 表示 daemon，`-r` 表示 repository, `--listen-port 3690` 表示在 `3690` 端口上监听。


## 关于 SVN 数据目录

SVN 数据目录有个根目录，其下可以有数个代码仓库。工作方式与 WWW 服务器类似，根目录对应了 `/`，根目录下的文件夹，分别对应各个代码仓库。比如 `svn://xfoss.com/artfacts-repo`，其中 `xfoss.com` 是主机名，其后的 `/` 是表示上面  `/svn/repository/directory` 的根目录，而 `artifacts-repo` 表示根目录下的某个文件夹。如此便可列出 SVN 数据文件夹根目录下的各个代码仓库文件夹。

## 代码仓库的口令文件 `passwd` 与授权文件 `authz`

两个文件都位于 SVN 数据文件夹根目录下，各个代码仓库文件夹下的 `conf` 文件夹中。


- 口令文件 `conf/passwd`
    其中记录了该代码仓库各个用户的用户名与明文的口令。`svnserve` 会以 HTTPAuth 方式，使用该文件，对用户进行认证。格式如下：

    ```
    username1 = abcdef
    username2 = hijklmn
    ...
    ```

- 授权文件 `conf/authz`
    记录了 `conf/passwd` 中定义的各个用户所属的组，以及代码仓库下各个子文件夹的读写权限的各个用户。格式如下。

    ```
    [groups]
    groupa = username1, username2...
    groupb = usrname2...

    [/]
    root = rw
    * = r

    [/pizza]
    usrname1 = r
    username2 = rw

    ...
    ```

## 代码仓库创建和检查


创建代码仓库：`svnadmin create /path/to/repository`

检查：`svnadmin verify /path/to/repository`


## 参考链接

- [RUNOOB：SVN 教程](https://www.runoob.com/svn/svn-tutorial.html)
