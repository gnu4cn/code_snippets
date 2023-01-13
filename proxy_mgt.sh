#!/usr/bin/bash
INFO_COLOR="\033[1;90;1;93m"
SUCESS_COLOR="\033[0;90;2;92m"
END_COLOR="\033[0m"
ALERT_COLOR="\033[5;47;1;31m"

COMMANDS=("start" "restart" "monitor")

start_conn() {
    /usr/bin/ssh -q -C -N -D 10080 user@example.com -p 38460 2>/dev/null

    if [ $? -ne 0 ]; then echo -e "${ALERT_COLOR}连接不上....${END_COLOR}"; fi
}

stop_conn() {
    pid=$(/usr/bin/ps -A -o pid,comm,args | grep 'xfoss.com' | head -n 1 | awk -F' ' '{print $1}')

    re='^[0-9]+$'
    if ! [[ $pid =~ $re ]] ; then
        :
    else
        kill $pid && sleep 5
    fi
}

monitor() {
    pid=$(/usr/bin/ps -A -o pid,comm,args | grep 'xfoss.com' | head -n 1 | awk -F' ' '{print $1}')

    re='^[0-9]+$'
    if ! [[ $pid =~ $re ]] ; then
        start_conn
    fi
}

declare -A paras

i=1;
for para in "$@"; do paras[$i]=$para && i=$((i + 1)); done

if [ $i != 2 ]; then
    echo "命令行参数问题。仅支持一个参数：start/restart/monitor" && exit 1
fi

cmd_okay=0
for cmd in ${COMMANDS[@]}; do
    if [ $1 == $cmd ]; then cmd_okay=1 && break; fi
done

if [ $cmd_okay -eq 0 ]; then
    echo "命令行参数错误" && echo "可选参数：${COMMANDS[@]}" && exit 1
fi

case $1 in
    "start")
        start_conn
        ;;
    "restart")
        stop_conn && start_conn
        ;;
    "monitor")
        monitor
        ;;
esac
