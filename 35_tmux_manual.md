# `tmux` 用法


`tmux` 是个 “终端复用器：他实现了数个终端（或者说视窗），每个都运行单独程序，这些终端可在单个屏幕，而被创建出来、被访问到，且被控制。`tmux` 可从屏幕上脱离，deattached, 并继续在后台运行，并在随后又被取回，reattached。”


## 安装 `tmux`

运行 `yay -S tmux` （ArchLinux/Manjaro）。


## `tmux` 常用命令

1. 创建出一个终端

    ```console
    $ tmux new -s ed
    ```

    创建出一个名为 `ed[itor]` 的终端，`-s` 命令行参数，是给新创建出的终端会话，一个字符串的 `session-name`。创建出终端会话后，便会立即进入该终端会话。


2. 按键绑定

    是指 `tmux` 中有大量命令按键绑定，command key bindings，这些命令默认都以 `Ctrl + b` 作为前缀，常用的按键绑定有：

    - 以竖直方式分割视窗，即为 `Ctrl+b %`

    - 从屏幕中脱离即为 `Ctrl+b d`

    - 列出所有终端会话 `Ctrl+b w`

    - 杀掉除当前所选终端外的其他所有终端会话 `Ctrl+b : kill-pane -a`



3. 取回脱离的终端会话


    ```console
    $ tmux attach -t ed
    ```

    其中的 `-t ed` 传入了名为 `ed` 的终端 Tab。
