#! /usr/bin/bash

sl status | awk -F'/' '{print $1}' | awk -F' ' '{print $2}' | while read line; do
    sl remove $line
done
