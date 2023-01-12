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

stop_srv() {
    if [ $(netstat -ntlp 2> /dev/null | grep ${ports[$1]} | wc -l) == 0 ]; then
        :
    else
        kill `/usr/bin/netstat -ntlp 2> /dev/null | grep ${ports[$1]} | awk -F' ' '{print $7}' | awk -F'/' '{print $1}'`
        sleep 1
    fi
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
