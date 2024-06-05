#!/usr/bin/env bash

for f in $(ls . | grep "tar.gz"); do
	echo "Exacting $f ..."
	tar xzf $f -C .
	rm -f $f
done
