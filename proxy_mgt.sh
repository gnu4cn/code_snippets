#!/usr/bin/bash
INFO_CLR="\033[1;90;1;93m"
SUCESS_CLR="\033[0;90;2;92m"
END_CLR="\033[0m"
ALERT_CLR="\033[5;47;1;31m"

COMMANDS=("start" "stop" "restart" "monitor" "status")

start_conn() {
    /usr/bin/ssh -q -C -N -D 10080 unisko@xfoss.com -p 38460 2>/dev/null &

    if [ $? -ne 0 ]; then echo -e "${ALERT_CLR}连接不上....${END_CLR}"; fi
}

stop_conn() {
    pid=$(/usr/bin/netstat -ntlp 2> /dev/null | grep "10080" | awk -F' ' '{print $7}' | awk -F'/' '{print $1}' | head -n 1)

    re='^[0-9]+$'
    if ! [[ $pid =~ $re ]] ; then
        :
    else
        kill $pid && sleep 5
    fi
}

monitor() {
    pid=$(/usr/bin/netstat -ntlp 2> /dev/null | grep "10080" | awk -F' ' '{print $7}' | awk -F'/' '{print $1}' | head -n 1)

    re='^[0-9]+$'
    if ! [[ $pid =~ $re ]] ; then
        start_conn
    fi
}

show_status() {
    echo "---------------------------------------------"
    echo -e "${INFO_CLR}SSH proxy${END_CLR} 状态:"
    pid=$(/usr/bin/netstat -ntlp 2> /dev/null | grep "10080" | awk -F' ' '{print $7}' | awk -F'/' '{print $1}' | head -n 1)

    re='^[0-9]+$'
    if ! [[ $pid =~ $re ]] ; then
        echo -e "${ALERT_CLR}----- Not connected !!!!!!! -----------------${END_CLR}"
    else
        echo -n -e "${SUCESS_CLR}"
        /usr/bin/ps -p $pid -o pid,vsz=MEMORY -o etime=ELAPSED_TIME -o state=STATE,stime=START_TIME
        echo -n -e "${END_CLR}"
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
    "status")
        show_status
        ;;
    "stop")
        stop_conn
        ;;
esac

exit 0
