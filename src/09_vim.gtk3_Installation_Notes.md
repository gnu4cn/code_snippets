# vim.gtk3 安装注意事项

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

> JDK 的安装：

>> 1. 下载 JDK 的 tar.gz 文件
>> 2. `$sudo tar xf jdk-xx.x.xx_linux-x64_bin.tar.gz -C /opt/`
>> 3. `$sudo ln -s /opt/jdk-xx.x.xx/ /opt/jdk`
>> 4. `$sudo update-alternatives --install "/usr/bin/java" "java" "/opt/jdk/bin/java" 1`
>> 5. `$sudo update-alternatives --install "/usr/bin/javac" "javac" "/opt/jdk/bin/javac" 1`

> 安装完成

```bash
$python install.py --ts-completer
```

## `gnome-terminal` 终端光标丢失问题

[ibus-pinyin 1.5.0 on debian 9 will hide terminal cursor](https://github.com/phuang/ibus-pinyin/issues/11)

> "Recently, I also encountered this problem. I solved this problem by unchecking the item 『Embed preedit text in application window』in the ibus preferences (run ibus-setup from the terminal."

## 使用 `Shougo/dein.vim` 来管理 Vim 插件

其中 `ycm-core/YouCompleteMe` 可手动 `git` 到 `~/.cache/dein/repos/github.com/ycm-core/YouCompleteMe`，然后运行 `python install.py --java-completer --ts-completer` 进行安装。
