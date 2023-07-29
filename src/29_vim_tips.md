# VIM 使用技巧


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
