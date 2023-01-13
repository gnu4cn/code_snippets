#!/usr/bin/bash
source $(dirname $0)/srv_incl.sh

for name in ${!dirs[@]}; do cd "$HOME/${dirs[$name]}" && npm run sl-checkout; done

for name in ${!dirs[@]}; do
    resp_code=$(/usr/bin/curl -I "https://${name}.xfoss.com/sitemap.xml" 2>/dev/null | head -n 1 | cut -d$' ' -f2)
    if [ $resp_code != 200 ]; then stop_srv $name && start_srv $name && sleep 120; fi
done

exit 0
