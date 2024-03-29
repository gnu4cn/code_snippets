# 在内网安装 Python 第三方包

参考：[如何在内网安装python第三方包（库）](https://blog.csdn.net/xue_11/article/details/112802149)


本文将采取参考链接中的第 3 种方法，批量安装 python 包。根据研发需求，要 `python 3.8.16` 环境，故首先安装 `python38` 包：`yay -S python38`，得到的 Python 版本为 `python 3.8.18`，与研发需求接近。然后运行 `mkdir temp && cd temp && python3.8 -m venv .venv`，建立 Python `venv` 环境。

然后，按照参考链接中的做法，首先：


- 在 `temp` 目录下的 `venv` 环境中，安装内网所需的 Python 包；

- 运行 `pip freeze --all > requirements.txt`，将这些所需的包，记录在 `requirements.txt` 文件中；

- 运行 `pip down -r requirements -d ~/packages_required/`，将这些所需包下载到 `~/packages_required/` 目录中；

- 将 `requirements.txt` 和 `packages_required` 文件夹，放在内网机器的同一文件夹下，执行 `pip install --no-index --find-links /path/to/packages_required -r requirements.txt`，就可以批量安装了。


**注意**：批量安装 `requirements.txt` 中的库时，建议将 `pip` 的安装包删掉，因为内网机器上以及有 `pip` 这个包了，删除时应将 `packages_required` 文件夹中的 `pip*.whl` 文件、`requirements.txt` 中 `pip` 这行删掉。
