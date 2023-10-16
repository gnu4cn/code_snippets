# 安装此应用注意事项


记录 `fire.fundersclub.com` 安装过程。


## 修改 `py-requirements/base.txt` 及 `py-requirements/dev.txt` 两个文件

需对 `py-requirements/base.txt`、`py-requirements/dev.txt` 两个文件做如下修改：


1. 修改 `base.txt` 中的行

`-e git+git://github.com/pennersr/django-allauth@83a0f77688f7d89939db454e3708d34e523accf3#egg=django-allauth`

修改为：

`-e git+https://github.com/pennersr/django-allauth@83a0f77688f7d89939db454e3708d34e523accf3#egg=django-allauth`


2. 修改 `base.txt` 中的行：

`psycopg2==2.7.7`

修改为：


`psycopg2==2.8.4`


3. 修改 `dev.txt` 中的行：


`ipdb==0.11`

修改为：

`ipdb==0.13`


## `npm` 安装时的问题

运行 `npm i` 命令时，会报出 `PhantomJS not found on PATH` 错误，此时需先执行 `npm i phantomjs@2.1.1 --ignore-scripts`，单独安装 `phantomjs`，再执行 `npm i` 安装其他 NPM 包。
