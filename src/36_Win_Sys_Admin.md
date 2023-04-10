# M$ Win 系统管理笔记

Win 系统使用心得与经验记录。

## Wins 安装过程中，激活码的问题

微软有专门的 [KMS Client Setup Keys](https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-server-2012-r2-and-2012/jj612867(v=ws.11))。

## Win11 22h2 安装过程中跳过 “Let's connect you to a network”


在这个界面，按下 `Shift + F10`，于命令行中输入 `OOBE\BYPASSNRO`，之后机器将重启，且 out-of-box eperience, OOBE 将再次启动。

## Win 系统下软件安装的几种方式

这里要讨论的，并非习以为常的经由下载安装程序并运行，或是从应用商店 App Store 安全软件。而是一些另类的软件安装方式。

### `chocolatey.exe` 方式

[chocolatey.org](https://chocolatey.org)，提出 Win 系统包管理器的概念，并声称其为 “现代的软件自动化”。实际使用起来，也较为方便。

```powershell
PS C:\Windows\system32> choco help
Chocolatey v1.1.0
This is a listing of all of the different things you can pass to choco.

DEPRECATION NOTICE

The shims `chocolatey`, `cinst`, `clist`, `cpush`, `cuninst` and `cup` are deprecated.
We recommend updating all scripts to use their full command equivalent as these will be
removed in v2.0.0 of Chocolatey.

Options and Switches

 -v, --version
     Version - Prints out the Chocolatey version. Available in 0.9.9+.

Commands

 * find - searches remote or local packages (alias for search)
 * list - lists remote or local packages
 * search - searches remote or local packages
 * help - displays top level help information for choco
 * info - retrieves package information. Shorthand for choco search pkgname --exact --verbose
 * install - installs packages using configured sources
 * pin - suppress upgrades for a package
 * outdated - retrieves information about packages that are outdated. Similar to upgrade all --noop
 * upgrade - upgrades packages from various sources
 * uninstall - uninstalls a package
 * pack - packages nuspec, scripts, and other Chocolatey package resources into a nupkg file
 * push - pushes a compiled nupkg to a source
 * new - creates template files for creating a new Chocolatey package
 * sources - view and configure default sources (alias for source)
 * source - view and configure default sources
 * config - Retrieve and configure config file settings
 * feature - view and configure choco features
 * features - view and configure choco features (alias for feature)
 * setapikey - retrieves, saves or deletes an apikey for a particular source (alias for apikey)
 * apikey - retrieves, saves or deletes an apikey for a particular source
 * unpackself - re-installs Chocolatey base files
 * export - exports list of currently installed packages
 * template - get information about installed templates
 * templates - get information about installed templates (alias for template)


Please run chocolatey with `choco command -help` for specific help on
 each command.
```

### MSYS2 方式

> MSYS2 亦可经由 `choco.exe` 加以安装。

> [msys2.org](https://msys2.org): **MSYS2** 是为构建、安装及运行原生 Windows 软件的易于上手环境，而提供的一些工具与库的集合。

> 其包含了叫做 `mintty` 的一个命令行终端、`bash`、诸如 `git` 及 `subversion, svn` 等版本管理工具，以及像是 `tar` 与 `awk`，甚至像 `autotools` 这样的构建系统，全部都是基于修改版的 [`Cygwin`](https://cygwin.com/)。

![MSYS2 终端](images/msys2-terminal.png)


## 删除用户配置文件

在删除 Win 系统用户时，除了要在 “计算机管理” 中删除用户，还要删除用户配置文件。有两种方式：

- 前往 `C:/Users/` 目录，删除对应用户名的文件夹；
- “我的电脑” -> “属性” -> "高级系统设置" -> “用户配置文件” -> “设置”

首选第二种方式；因为第一种删除文件夹的方式，可能出现权限问题删除不了，而第二种方式则没有这方面的问题。


## AD 下用户证书申请与导出


### 申请新证书


在 “管理控制台” （按下 `Win + R` 输入 `mmc` 打开）中，“文件” -> “添加/删除管理单元” -> “证书” -> “我的用户账户”，在 “个人” 上点击右键，选择 “所有任务” -> “申请新证书”


### 导出证书

需要选择 “导出私钥” 选项，必要时为证书设置密码。
