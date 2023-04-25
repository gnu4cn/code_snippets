# `tmux` 用法


`tmux` 是个 “终端复用器：他实现了数个终端（或者说视窗），每个都运行单独程序，这些终端可在单个屏幕，而被创建出来、被访问到，且被控制。`tmux` 可从屏幕上脱离，deattached, 并继续在后台运行，并在随后又被取回，reattached。”


## 安装 `tmux`

运行 `yay -S tmux` （ArchLinux/Manjaro）。


## `tmux` 常用命令

### 创建出一个终端

```console
$ tmux new -s ed
```

创建出一个名为 `ed[itor]` 的终端，`-s` 命令行参数，是给新创建出的终端会话，一个字符串的 `session-name`。创建出终端会话后，便会立即进入该终端会话。


### 按键绑定

是指 `tmux` 中有大量命令按键绑定，command key bindings，这些命令默认都以 `Ctrl + b` 作为前缀，常用的按键绑定有：

- 以竖直方式分割视窗，即为 `Ctrl+b %`

- 从屏幕中脱离即为 `Ctrl+b d`

- 列出所有终端会话 `Ctrl+b w`

- 杀掉除当前所选终端外的其他所有终端会话 `Ctrl+b : kill-pane -a`

- 移到上一终端会话 `Ctrl+b Shift+9`

- 移到下一终端会话 `Ctrl+b Shift+0`

- 杀死当前会话 `Ctrl+b x y`


### 取回脱离的终端会话


```console
$ tmux attach -t ed
```

其中的 `-t ed` 传入了名为 `ed` 的终端 Tab。


### 杀死会话

运行命令：

```console
$ tmum kill-session -t sh
```

杀死名为 `sh` 的会话。


### `tmux` 与 `vim` 终端颜色配置问题


参考：[lose vim colorscheme in tmux mode](https://stackoverflow.com/a/10264470)

要解决此问题，就有在 `.zshrc`/`.bashrc` 中设置：

```sh
alias tmux="TERM=screen-256color-bce tmux"
```

并在 `~/.tmux.conf` 中设置 `default-terminal` 选项：

```conf
set -g default-terminal "xterm"
```

最后，要执行 `$ source ~/.zshrc` 或 `$ source ~/.bashrc` 加载新的命令别名。

要使上述设置在系统范围生效，可分别建立 `/etc/profile.d/tmux.sh` 与 `/etc/tmux.conf` 然后把上述配置分别写入这两个文件。

## Tmux 光标偏移问题

参见：[(SOLVED) Tmux cursor position shifts](https://github.com/martanne/vis/issues/763)


在 `~/.bashrc`/`~/.zshrc`/`.kshrc` 文件中加入：

```sh
LC_ALL=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
LANG=en_US.UTF-8
```


## 没有窗口滚动条的问题


> 注：后面发现此问题特定于运行在 `msys2` 下的 `tmux` 才出现，而发现 `msys2` 有个 “用于鼠标滚动的修饰键” 选项，故只需按住鼠标修饰键，就无需额外设置，便可在运行于 `msys2` 下 `tmux` 窗口中，通过滚动鼠标滚轮而上下翻页。

参考：[How do I scroll in tmux?](https://superuser.com/a/510310)

在 `~/.tmux.conf` 中加入：

```conf
set -g mouse on     # 对于 2.1 以上版本的 tmux
```

或

```conf
set -g mode-mouse on     # 对于 2.1 以下版本的 tmux
```

然后运行以下命令：

```console
tmux source-file ~/.tmux.conf
```

即可在 `tmux` 窗口中通过鼠标滚轮向上翻页。


