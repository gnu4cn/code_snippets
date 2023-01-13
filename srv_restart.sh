#!/usr/bin/bash

declare -A dirs

dirs["rust-lang"]="rust-lang"
dirs["java-lang"]="learningJava"
dirs["ccna"]="ccna60d"
dirs["ts-lang"]="ts-learnings"
dirs["www"]="buy-me-a-coffee"

declare -A ports

dirs["rust-lang"]="10443"
dirs["java-lang"]="10445"
dirs["ccna"]="10444"
dirs["ts-lang"]="10447"
dirs["www"]="10446"

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
