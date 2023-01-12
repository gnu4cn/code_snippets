#!/usr/bin/bash

declare -A names

names["rust-lang"]="rust-lang"
names["java-lang"]="learningJava"
names["ccna"]="ccna60d"
names["ts-lang"]="ts-learnings"
names["www"]="buy-me-a-coffee"

for name in ${!names[@]}; do
    cd "$HOME/${names[$name]}" && npm run sl-checkout && sleep 60
done

for name in ${!names[@]}; do
    curl "https://${name}.xfoss.com/sitemap.xml" &> /dev/null
    if [ $? != 0 ]; then
        cd "$HOME/${names[$name]}" && npm run serve && sleep 300
    fi
done

exit 0
