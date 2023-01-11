#!/usr/bin/bash

declare -A names

names["rust-lang"]="rust-lang"
names["java-lang"]="learningJava"
names["ccna"]="ccna60d"
names["ts-lang"]="ts-learnings"
names["www"]="buy-me-a-coffee"

in_problem=0

for name in ${!names[@]}; do
    cd "$HOME/${names[$name]}" && npm run sl-checkout && sleep 60
done

for name in ${!names[@]}; do
    curl "https://"$name".xfoss.com/sitemap.xml" &> /dev/null
    if [ $? != 0 ]; then
        in_problem=1 && break
    fi
done

if [ in_problem == 1 ]; then
    ps -A | grep node | while read -r line; do
        kill $(echo $line | awk -F' ' '{print $1}') && sleep 60
    done

    for name in ${!names[@]}; do
        cd "$HOME/${names[$name]}" && npm run serve && sleep 300
    done
fi

exit 0
