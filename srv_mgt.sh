#!/usr/bin/bash
source $(dirname $0)/srv_incl.sh

declare -A paras

i=1;
for para in "$@"; do paras[$i]=$para && i=$((i + 1)); done

if [ $i != 3 ]; then
    echo "命令行参数问题。仅支持两个参数：start/stop/restart/status, all/service_name"
    echo "command: ${COMMANDS[@]}"
    echo "service_name: ${!dirs[@]}" && exit 1
fi

cmd_okay=0
for cmd in ${COMMANDS[@]}; do
    if [ $1 == $cmd ]; then cmd_okay=1 && break; fi
done

if [ $cmd_okay -eq 0 ]; then
    echo "第一个命令行参数错误"
    echo "可选参数：${COMMANDS[@]}" && exit 1
fi

option_okay=0
for opt in ${OPTIONS[@]}; do
    if [ $2 == $opt ]; then option_okay=1 && break; fi
done

if [ $option_okay -eq 0 ]; then
    echo "第二个命令行参数错误"
    echo "可选参数：${OPTIONS[@]}" && exit 1
fi

case $1 in
    "start")
        do_start $2
        ;;
    "stop")
        do_stop $2
        ;;
    "restart")
        do_restart $2
        ;;
    "status")
        show_status $2
        ;;
    "monitor")
        monitor $2
        ;;
esac

exit 0
