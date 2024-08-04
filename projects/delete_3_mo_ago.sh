#!/usr/bin/env bash

let PERIOD=90


echo "Delete things 3 months(90 days) ago."

for item in $(find . -maxdepth 1 -not -name '.' -not -name '.*' -mtime +$PERIOD); do
	rm -rf "$item"
done
