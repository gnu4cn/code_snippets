#!/usr/bin/env bash

# 定义终端字体颜色
yellow=`tput setaf 3`
blue=`tput setaf 4`
reset=`tput sgr0`

# 定义一个 branch 数组
CLI_FLAGS=("release_nightly" "release_beta" "release_stable")
declare -A paras

# 检查命令行参数
i=1;
for para in "$@"; do paras[$i]=$para && i=$((i + 1)); done

if [ $i != 3 ]; then
    echo "CLI command flags problem. Only one CLI flag supported：release_nightly/release_beta/release_stable"
    echo "command: ${CLI_FLAGS[@]} 'commit_msg_str'" && exit 1
fi

cmd_okay=0
for cmd in ${CLI_FLAGS[@]}; do
    if [ $1 == $cmd ]; then cmd_okay=1 && break; fi
done

if [ $cmd_okay -eq 0 ]; then
    echo "CLI flags error."
    echo "Flags available: ${CLI_FLAGS[@]}" && exit 1
fi

# 开始进行 merge master 操作
cd $HOME/wise


# 日志开始
echo -e "\n------------------- New log start (`date "+%Y/%m/%d"`) ---------------\n"

# 更新 submodule
git submodule update --recursive
git add . && git commit -m "$(date -u +"%FT%TZ") - $2"

# 更新 master 分支
git checkout master && git pull
git submodule update --recursive
git checkout "$1" && git pull

# 合并 master 分支，并 push 到 github.com
git merge master --no-ff --no-edit
git add . && git commit -m "$(date -u +"%FT%TZ") - $2"
git push
