#!/usr/bin/bash

if [ `/usr/bin/netstat -tlnp 2> /dev/null | grep 10080 | wc -l` = 0 ]; then
    /usr/bin/ssh -q -C -N -D 10080 unisko@xfoss.com -p 38460 &
fi
