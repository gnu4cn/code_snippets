# Python tips


本文记录 Python 的一些技巧、疑难现象。


## `python setup.py install` 下修改源


- 修改 `~/.pydistutils.cfg`


```conf
[easy_install]
index_url = https://pypi.tuna.tsinghua.edu.cn/simple
```


- 修改/创建 `setup.py` 所在目录下的 `setup.cfg`，加入：



```conf
[easy_install]
index_url = https://pypi.tuna.tsinghua.edu.cn/simple
```



> **参考**：[关于使用setup.py下载库修改源的问题](https://blog.csdn.net/qq_36852276/article/details/100740865)


## 在内网安装 Python 第三方包

参考：[如何在内网安装python第三方包（库）](https://blog.csdn.net/xue_11/article/details/112802149)


本文将采取参考链接中的第 3 种方法，批量安装 python 包。根据研发需求，要 `python 3.8.16` 环境，故首先安装 `python38` 包：`yay -S python38`，得到的 Python 版本为 `python 3.8.18`，与研发需求接近。然后运行 `mkdir temp && cd temp && python3.8 -m venv .venv`，建立 Python `venv` 环境。

然后，按照参考链接中的做法，首先：


- 在 `temp` 目录下的 `venv` 环境中，安装内网所需的 Python 包；

- 运行 `pip freeze --all > requirements.txt`，将这些所需的包，记录在 `requirements.txt` 文件中；

- 运行 `pip down -r requirements -d ~/packages_required/`，将这些所需包下载到 `~/packages_required/` 目录中；

- 将 `requirements.txt` 和 `packages_required` 文件夹，放在内网机器的同一文件夹下，执行 `pip install --no-index --find-links /path/to/packages_required -r requirements.txt`，就可以批量安装了。


**注意**：批量安装 `requirements.txt` 中的库时，建议将 `pip` 的安装包删掉，因为内网机器上以及有 `pip` 这个包了，删除时应将 `packages_required` 文件夹中的 `pip*.whl` 文件、`requirements.txt` 中 `pip` 这行删掉。



## `import git` 报出 `Segmentation fault`


![`import git` 报出 `Segmentation fault` 错误](images/import-git-segmentation-fault.png)

此问题较难发现、解决，耗时较长。期间发现 `import git` 疑似与 `GitPython` 相关，但实则是 `python-git` 所提供。

随后偶然发现在 `import pygit` 随后再 `import git` 时，就不报 `Segmentation fault` 错误了。且随后可以在 Python 程序中使用 `git` 这个模块了。


![`import git` 成功](images/import-git.png)


![使用导入的 `git` 模块](images/using-pygit.png)


## `import pandas` 报出 `segmentation fault`


Python 3.6.8 中，运行程序时，始终报出 `segmentation fault`。逐一排查，程序依赖 `pandas` 包，而 `pandas` 包又依赖 `numpy` 这个包。在环境中成功安装了 `numpy` 包后直接 `import numpy` 时，会报出 `segmentation fault`。


此问题并非个例，如：[Segmentation fault (core dumped) while trying to print numpy and pandas objects in python via cygwin](https://stackoverflow.com/questions/70511576/segmentation-fault-core-dumped-while-trying-to-print-numpy-and-pandas-objectshttps://stackoverflow.com/questions/70511576/segmentation-fault-core-dumped-while-trying-to-print-numpy-and-pandas-objects)。


但是，与上一个 `import git` 报 `segmentation fault` 类似，在 `import pandas`（或 `import numpy`）前，放一个 `import pip` 的行，就不会再报出 `segmentation fault` 错误。
