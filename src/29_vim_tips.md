# VIM 使用技巧

在新系统配置 vim.gtk3 时，需要重新安装 `NeoBundle`, `vim.plug` 插件管理器。还需要重新安装 YouCompleteMe 插件。

## 00. NeoBundle 插件管理器的安装

```bash
$ mkdir ~/.vim/bundle
$ git clone https://github.com/Shougo/neobundle.vim ~/.vim/bundle/neobundle.vim
```

安装 NeoBundle 之后，就可以在 Vim 中运行 `:NeoBundleList` 和 `:NeoBundleInstall(!)` 来列出和安装更新其所管理的插件了。

## 01. `vim.plug` 的安装

```bash
$mkdir .vim/autoload
$cp ~/code_snippets/vim.plug ~/.vim/autoload/
```

之后在 Vim 中运行 `:PlugInstall` 来安装 `plug.vim` 所管理的插件。

## 02. Python poetry 的安装

```bash
$sudo apt install python3-pip
$pip install --user poetry
$echo 'PATH=${PATH}:~/.local/bin >> ~/.bashrc'
```

## 03. YouCompleteMe 的安装

安装编译工具：

```bash
$sudo apt install build-essential cmake vim-nox python3-dev
```

运行下面的命令，克隆子模块。

```bash
$cd ~/.vim/bundle
$git clone git@github.com:ycm-core/YouCompleteMe
$git submodule update --init --recursive
```

安装各种语言的补全之前，需要满足各种条件。比如安装 TyepScript 的支持（`--ts-completer`），就需要先安装 Node.js 与 npm；要有 Java 的支持（`--java-completer`），就要有 JDK。

JDK 的安装：

>> 1. 下载 JDK 的 tar.gz 文件
>> 2. `$sudo tar xf jdk-xx.x.xx_linux-x64_bin.tar.gz -C /opt/`
>> 3. `$sudo ln -s /opt/jdk-xx.x.xx/ /opt/jdk`
>> 4. `$sudo update-alternatives --install "/usr/bin/java" "java" "/opt/jdk/bin/java" 1`
>> 5. `$sudo update-alternatives --install "/usr/bin/javac" "javac" "/opt/jdk/bin/javac" 1`

安装完成

```bash
$python install.py --ts-completer
```

## `gnome-terminal` 终端光标丢失问题

[ibus-pinyin 1.5.0 on debian 9 will hide terminal cursor](https://github.com/phuang/ibus-pinyin/issues/11)

> "Recently, I also encountered this problem. I solved this problem by unchecking the item 『Embed preedit text in application window』in the ibus preferences (run ibus-setup from the terminal."


## 使用 `Shougo/dein.vim` 来管理 Vim 插件

其中 `ycm-core/YouCompleteMe` 可手动 `git` 到 `~/.cache/dein/repos/github.com/ycm-core/YouCompleteMe`，然后运行 `python install.py --java-completer --ts-completer` 进行安装。


## 使用 `coc.nvim` 时，找不到 `utilsnips` 目录的问题

在 Windows 系统上的 `msys2` 环境下运行安装了 `coc` 插件的 `vim`，默认会报出 `~/.vim/coc-data/utilsnips` 找不到的问题，此时需在 `.vimrc` 文件中加入下面这行：

```vimrc
let g:coc_data_home="/tools/msys64/home/Lenny.Peng/.vim/coc-data/"
```

指向 `coc-data` 的正确位置，随后再度启动 `vim` 将自动按照 `coc.nvim` 本身的一些依赖，并不再报出上面目录找不到的问题。


这里记录 VIM 的一些使用技巧。


## 使用 `coc.nvim` 的 `~/.vimrc`

这个 `.vimrc` 简单好用，特记录于此。

```vimrc
{{#include ../projects/coc.nvim-vimrc}}
```


## `coc.nvim` 插件的配置文件

使用 `:CocConfig` 可以打开 `coc.nvim` 的配置文件。示例配置文件如下。

```json
{{#include ../projects/coc-settings.json}}
```

这个配置文件主要对 `rust-analyzer` 与 [`coc-rust-analyzer`](https://github.com/fannheyward/coc-rust-analyzer#configurations) 进行了配置。其中 `coc-rust-analyzer` 是通过 `vim` 的以下命令安装的。


```bash
:CocInstall coc-rust-analyzer
```

## 查找两个汉字之间的 ASCII 字符串：

`:%s/[^\x00-\x7f]\zs[A-Za-z0-9.]\+\ze/ & /g`

其中：

- `%s/` - 指在整个文件中查找；
- `[^\x00-\x7f]` - Unicode 汉字部分
- `\zs...\ze` - 只查找和替换的部分边界
- `[a-zA-Z0-9.]\+` - 正则表达式
- `/ & /g` - `&` 表示前面  `\zs...\ze` 中的 `...`

## 围栏代码块

**Fenced Code Blocks**

参考：[Fenced Code Blocks](https://www.markdownguide.org/extended-syntax/#fenced-code-blocks)

基本 Markdown 语法允许咱们通过缩进 4 个空格或一个制表符，创建代码块。而当咱们发现那样不方便时，就要尝试使用围栏代码块。依据咱们的 Markdown 处理器或编辑器，咱们将在代码块的前一行与后一行上，使用三个反引号（backtick, `` ` ``）或三个波浪号（代字号，tilde, `~`）。最重要的是什么？那就是咱们不必缩进任何行！

~~~text
```json
{
    "firstName": "John",
    "lastName": "Smith",
    "age": 25
}
```
~~~

渲染出的数据看起来是这样的：

```json
{
    "firstName": "John",
    "lastName": "Smith",
    "age": 25
}
```

> 注：上面为了在代码块中显示 `` ``` ``，使用了 `~~~` 方式。


## 在多个行前插入文本

1. 按下 `Esc` 进入 “命令模式”；

2. 使用 `Ctrl + V` 进入可视块模式；

3. 按 `Up`/`Down` 键选择咱们要注释的行；

4. 然后按 `Shift + i`，并输入咱们打算插入的文本；

5. 随后按下 `Esc`，等 1 秒钟，插入的行就会出现在每一行上。

参考：[How to insert text at beginning of a multi-line selection in vi/Vim](https://stackoverflow.com/a/253391)


## `%s` 中模式匹配与捕获


在要将 `**图 n.m, xxxxx**` 这样的大写文字，批量修改为 `### 图 n.m，xxx` 这样的标题时，就要用到 Vim 中，用到模式匹配与捕获特性。使用下面的命令：


```vim
:%s/\*\*图\(.*\)\*\*/\#\#\#\ 图\1/g
```

其中 `\(.*\)`，就表示要捕获 `图` 字后面、`**` 前面的任意个字符。而后面替换字符串中的 `\1`，就表示这个捕获的子字符串。
