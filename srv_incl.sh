COMMANDS=("start" "stop" "restart" "status")
RED="31"
GREEN="32"
ORANGE="33[93m"
BOLDGREEN="\e[1;${GREEN}m"
ITALICRED="\e[3;${RED}m"
ITALICORANGE="\e[3;${ORANGE}m"
ENDCOLOR="\e[0m"

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

stop_srv() {
    if [ $(netstat -ntlp 2> /dev/null | grep ${ports[$1]} | wc -l) == 0 ]; then
        :
    else
        kill `/usr/bin/netstat -ntlp 2> /dev/null | grep ${ports[$1]} | awk -F' ' '{print $7}' | awk -F'/' '{print $1}'`
        sleep 1
    fi
}

start_srv() {
    cd "$HOME/${dirs[$1]}" && npm run serve && sleep 120
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

show_status() {
    echo "---------------------------------------------"
    echo "$name.xfoss.com 状态:"
    pid=$(/usr/bin/netstat -ntlp 2> /dev/null | grep ${ports[$1]} | awk -F' ' '{print $7}' | awk -F'/' '{print $1}')

    re='^[0-9]+$'
    if ! [[ $pid =~ $re ]] ; then
        echo -e "\e[32m---- Dead !!!!!!!\e[0m"
    else
        /usr/bin/ps -p $pid -o pid,vsz=MEMORY -o etime=ELAPSED_TIME -o state=STATE,stime=START_TIME
    fi
}
