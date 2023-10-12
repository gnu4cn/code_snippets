# Sh/Bash 技巧

## 在当前目录及其所有子目录下，查找并删除所有某类型的文件

```console
$ find . -name '*.pyc'
$ find . -name '*.pyc' -delete
```


## 批量删除文件夹（保留想要的文件夹）

```bash
ls | grep -w -v -e "lenny" -e "sw" | xargs rm -rf
```

> **注**：其中当前文件夹下，匹配 `lenny` 与 `sw` 的文件夹将被保留。


## 替换文件夹中所有文件名包含 `log` 文件的字符串

```bash
ls | grep log | xargs sed -i 's/text-wrap: wrap;/text-wrap: wrap; white-space: pre-wrap;/g'
```

> **注**：将匹配当前文件夹下，文件名中包含 `log` 的文件，并将这些文件中的 `text-wrap: wrap;` 字符串，替换为 `text-wrap: wrap; white-space: pre-wrap;`，实现 HTML 的 `pre` 元素，在 Chrome（WebKit） 与 Firefox(Gecko) 下，都能自动断行。


## 建立与更新软链接

```bash
// 建立软链接
$ ln -s File link
// 更新软链接
$ ln -vfns File1 link
```
