#!/usr/bin/bash

COMMANDS=("start" "stop" "restart")

declare -A dirs

dirs["rust-lang"]="rust-lang"
dirs["java-lang"]="learningJava"
dirs["ccna"]="ccna60d"
dirs["ts-lang"]="ts-learnings"
dirs["www"]="buy-me-a-coffee"

declare -A ports

ports["rust-lang"]="10443"
ports["java-lang"]="10445"
ports["ccna"]="10444"
ports["ts-lang"]="10447"
ports["www"]="10446"

OPTIONS=("all")
for name in ${!dirs[@]}; do OPTIONS=(${OPTIONS[@]} "${name}"); done

declare -A paras

i=1;
for para in "$@"
do
    paras[$i]=$para;
    i=$((i + 1));
done

stop_srv() {
    kill `/usr/bin/netstat -ntlp 2> /dev/null | grep ${ports[$1]} | awk -F' ' '{print $7}' | awk -F'/' '{print $1}'`
    sleep 1
}

start_srv() {
    cd "$HOME/${dirs[$1]}" && npm run serve && sleep 300
}

start_all() {
    for name in ${!dirs[@]}; do
        cd "$HOME/${dirs[$name]}" && npm run serve && sleep 300
    done
}

kill_all() {
    ps -A | grep node | while read -r line; do
        kill $(echo $line | awk -F' ' '{print $1}') && sleep 60
    done
}

echo $i
if [ $i != 3 ]; then
    echo "命令行参数问题。仅支持两个参数：start/stop/restart, all/service_name"
    echo "service_name: rust-lang, java-lang, ccna, www, ts-lang"
    exit 1
fi

cmd_okay=0
for cmd in ${COMMANDS[@]}; do
    if [ $1 == $cmd ]; then cmd_okay=1 && break; fi
done

if [ $cmd_okay -eq 0 ]; then
    echo "第一个命令行参数错误"
    echo "可选参数：${COMMANDS[@]}"
    exit 1
fi

option_okay=0
for opt in ${OPTIONS[@]}; do
    if [ $2 == $opt ]; then option_okay=1 && break; fi
done

if [ $option_okay -eq 0 ]; then
    echo "第二个命令行参数错误"
    echo "可选参数：${OPTIONS[@]}"
    exit 1
fi

if [ $1 == "start" ] && [ $2 != "all" ]; then start_srv $2 exit 0; fi

if [ $1 == "stop" ] && [ $2 != "all" ]; then stop_srv $2 && exit 0; fi

if [ $1 == "restart" ] && [ $2 != "all" ]; then stop_srv $2 && start_srv $2 && exit 0; fi

if [ $2 == "all" ]; then
    if [ $1 == "start" ]; then start_all && exit 0; fi
    if [ $1 == "stop" ]; then kill_all && exit 0; fi
    if [ $1 == "restart" ]; then kill_all && start_all && exit 0; fi
fi
