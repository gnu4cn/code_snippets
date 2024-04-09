# GCC 与 GLIBC 问题

今日，用户提出了要使用 GCC 11.4.0 来编译研发源码的问题。Linux 服务器环境是 CentOS EL7，首先在联网的一台 CentOS EL7 机器上，使用本地 GCC（4.8.0） 构建出 GCC 11.4.0，放在目标 Linux 服务器上后，出现以下问题。


##  `/lib64/libstdc++.so.6: version 'GLIBCXX 3.4.21' not found`


这是因为在使用新的 `gcc` (`/opt/gcc-11.4.0/bin/gcc`) 编译代码时，找不到所需的 `libstdc++.so.6` 所致。解决办法：


```console
export LD_LIBRARY_PATH=/opt/gcc-11.4.0/lib64:$LD_LIBRARY_PATH
```

将 `/opt/gcc-11.4.0/lib64` 添加到 `LD_LIBRARY_PATH` 这个环境变量中。


## `/lib64/libm.so.6: version'GLIBC_2.27' not found` 


此问题正在解决中，预计需要重新构建 GLIBC。
