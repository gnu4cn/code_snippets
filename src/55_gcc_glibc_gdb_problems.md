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

重新构建 GLIBC 2.27 时，需要使用 GCC 7.3.0 和 GNU Make 4.2.1；因此需要首先构建指定版本的这两个工具。


在执行 `../configure ...` 后，就要使用 `/opt/make-4.2.1/bin/make`，在 `build` 目录下，直接调用 GNU Make 4.2.1 工具，进行 GLIBC 2.27 的构建。


经测试，使用 GCC 7.3.0 和 GNU Make 4.1 构建 GLIBC 2.29 没有问题。

**注意**：在系统（CentOS EL7）上存在多个 GLIBC 时，不能 `export LD_LIBRARY_PATH=/opt/glibc-2.27/lib:$LD_LIBRARY_PATH`，这样在执行系统工具（如：`ls`、`ps`）时，会报出 `Segmentation fault` 错误。而应 `export LD_LIBRARY_PATH=/lib64:/opt/glibc-2.27/lib:$LD_LIBRARY_PATH`，避免此类错误。


## 从源码构建 GDB


由于 GDB 依赖 GMP 和 MPFR（MPFR 又依赖 GMP），故要先安装 GMP、MPFR，再安装 GDB。GMP 和 MPFR 的源码，在安装 GCC 时，通过 `contrib/download_prerequistes` 可以获取到。


在构建 MPFR 时，需要通过 `--with-gmp=/opt/gmp-6.1.0`，为 MPFR 指定 GMP 所在的位置。构建好 MPFR 后，就可以开始构建 GDB 了。需要通过使用：


```console
./configure --prefix=/opt/gdb-14.2 CFLAGS="-I/opt/mpfr-3.1.6/include -L/opt/mpfr-3.1.6/lib -I/opt/gmp-6.1.0/include -L/opt/gmp-6.1.0/lib" CXXFLAGS="-I/opt/mpfr-3.1.6/include -L/opt/mpfr-3.1.6/lib -I/opt/gmp-6.1.0/include -L/opt/gmp-6.1.0/lib"
```

为 GDB 指定其所需的 GMP、MPFR 库文件和头文件。随后运行：


```console
make
make check
sudo make install
```


参考：

1. [How To Install GCC on CentOS 7](https://linuxhostsupport.com/blog/how-to-install-gcc-on-centos-7/)

2. [Intro to ‘make’ Linux Command: Installation and Usage](https://ioflood.com/blog/install-make-command-linux/#Installing_8216make8217_Command_from_Source_Code)

3. [centos7升级glibc2.28](https://blog.csdn.net/nangonghen/article/details/132258675)

4. [下载最新的glibc库并临时使用，而不污染原有系统环境](https://www.cnblogs.com/saolv/p/9762842.html)

5. [GCC and linking environment variables and flags](https://stackoverflow.com/a/16047559/12288760)

6. [gmp is missing while configuring building gdb from source](https://stackoverflow.com/a/70384197/12288760)
