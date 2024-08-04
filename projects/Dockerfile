# 选择 hub.docker.com 上的 jenkins/ssh-agent:debian-jdk11 基础镜像
FROM jenkins/ssh-agent:debian-jdk11
# 切换到 root
USER root
# 安装所需的 Debian 软件包
RUN apt update && apt install -y ncat wget build-essential python3 python3-dev python3-pip libc6-dev vim libevent-dev libnl-3-dev automake rsync curl
# 安装 Python 软件包
RUN pip3 install --upgrade pip --break-system-packages
RUN pip3 install --force-reinstall -v "imgtool==1.9.0" --break-system-packages
# 建立 nds32 工具链目录
RUN mkdir /opt/nds32le-elf-mculib-v5
# 从 gitlab.xfoss.com 下载 nds32 工具链压缩包并解压缩到上面的目录
RUN wget https://gitlab.xfoss.com/it-group/nds-toolchain/-/raw/21aade02c2d51747017b73d15bc03ee3e4ebc298/nds32le-elf-mculib-v5.tar.gz -O - | tar -xzf - -C /opt/nds32le-elf-mculib-v5
# RUN ln -s /usr/bin/python3 /bin/python3
# 切换到 jenkins 用户
USER jenkins
# 为 github.com 设置 ssh 代理
RUN touch /home/jenkins/.ssh/config
RUN echo "Host github.com\n\tHostname github.com\n\tServerAliveInterval 55\n\tForwardAgent yes\n\tProxyCommand /usr/bin/ncat --proxy 192.168.30.51:3128 %h %p" > /home/jenkins/.ssh/config
# 建立 gcc-arm 工具链目录
RUN mkdir -p /home/jenkins/TOOLCHAIN
# 从 gitlab.xfoss.com 下载 gcc-arm 工具链压缩包并解压缩到上面建立的目录
RUN wget https://gitlab.xfoss.com/it-group/nds-toolchain/-/raw/main/gcc-arm-none-eabi-7-2017-q4-major-linux.tar.bz2 -O - | tar -jxf - -C /home/jenkins/TOOLCHAIN
RUN mkdir -p /home/jenkins/bin
RUN /bin/bash -c 'for i in /home/jenkins/TOOLCHAIN/gcc-arm-none-eabi-7-2017-q4-major/bin/arm-none-eabi-*; do rm -f /home/jenkins/bin/${i##*/}; ln -s $i /home/jenkins/bin/${i##*/}; done'
# 建立两个工具链的 PATH 环境变量
ENV PATH="${PATH}:/home/jenkins/bin:/opt/nds32le-elf-mculib-v5/bin"
USER root
