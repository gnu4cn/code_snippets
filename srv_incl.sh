INFO_CLR="\033[1;90;1;93m"
SUCESS_CLR="\033[0;90;2;92m"
END_CLR="\033[0m"
ALERT_CLR="\033[5;47;1;31m"

declare -A dirs

dirs["rust-lang"]="rust-lang"
dirs["java-lang"]="learningJava"
dirs["ccna"]="ccna60d"
dirs["ts-lang"]="ts-learnings"
dirs["www"]="buy-me-a-coffee"
dirs["snippets"]="code_snippets"

declare -A ports

ports["rust-lang"]="10443"
ports["java-lang"]="10445"
ports["ccna"]="10444"
ports["ts-lang"]="10447"
ports["www"]="10446"
ports["snippets"]="10448"

COMMANDS=("start" "stop" "restart" "monitor" "status")
OPTIONS=("all")
for name in ${!dirs[@]}; do OPTIONS=(${OPTIONS[@]} "${name}"); done

stop_srv() {
    proc_num=`/usr/bin/netstat -ntlp 2> /dev/null | grep "${ports[$1]}" | wc -l`
    if [ $proc_num -eq 0 ]; then
        :
    else
        kill `/usr/bin/netstat -ntlp 2> /dev/null | grep ${ports[$1]} | awk -F' ' '{print $7}' | awk -F'/' '{print $1}'`
        sleep 1
    fi
}

start_srv() {
    proc_num=`/usr/bin/netstat -ntlp 2> /dev/null | grep "${ports[$1]}" | wc -l`
    if [ $proc_num -eq 1 ]; then
        :
    else
        cd "$HOME/${dirs[$1]}" && npm --max_old_space_size=144 run serve && sleep 120
    fi
}

start_all() {
    for name in ${!dirs[@]}; do
        start_srv $name && sleep 120
    done
}

kill_all() {
    /usr/bin/ps -A | grep node | while read -r line; do
    kill $(echo $line | awk -F' ' '{print $1}') && sleep 60
done
}

show_status() {
    echo "---------------------------------------------"
    echo -e " ${INFO_CLR}$name.xfoss.com${END_CLR} 状态:"
    pid=$(/usr/bin/netstat -ntlp 2> /dev/null | grep ${ports[$1]} | awk -F' ' '{print $7}' | awk -F'/' '{print $1}')

    re='^[0-9]+$'
    if ! [[ $pid =~ $re ]] ; then
        echo -e "${ALERT_CLR}----- Dead !!!!!!!${END_CLR}"
    else
        echo -n -e "${SUCESS_CLR}"
        /usr/bin/ps -p $pid -o pid,vsz=MEMORY -o etime=ELAPSED_TIME -o state=STATE,stime=START_TIME
        echo -n -e "${END_CLR}"
    fi
}

chk_n_restart() {
                resp_code=$(/usr/bin/curl -I "https://$1.xfoss.com/sitemap.xml" 2>/dev/null | head -n 1 | cut -d$' ' -f2)
                if [ $resp_code != 200 ]; then stop_srv $1 && start_srv $1 && sleep 120; fi

}

monitor() {
    case $1 in
        "all")
            for name in ${!dirs[@]}; do cd "$HOME/${dirs[$name]}" && npm run sl-checkout; done

            sleep 30

            for name in ${!dirs[@]}; do chk_n_restart $name; done
            ;;
        *)
            cd "$HOME/${dirs[$1]}" && npm run sl-checkout;
            sleep 30
            resp_code=$(/usr/bin/curl -I "https://$1.xfoss.com/sitemap.xml" 2>/dev/null | head -n 1 | cut -d$' ' -f2)
            if [ $resp_code != 200 ]; then stop_srv $1 && start_srv $name && sleep 120; fi
            ;;
    esac
}
