INFO_CLR="\033[1;90;1;93m"
SUCESS_CLR="\033[0;90;2;92m"
END_CLR="\033[0m"
ALERT_CLR="\033[5;47;1;31m"
LOG_FILE="${HOME}/log/srv_mgt.log"

declare -A dirs

dirs["rust-lang"]="rust-lang-zh_CN"
dirs["java"]="learningJava"
dirs["ccna60d"]="ccna60d"
dirs["ts"]="ts-learnings"
dirs["www"]="buy-me-a-coffee"
dirs["snippets"]="code_snippets"
dirs["jenkins"]="jenkins_book_zh"
dirs["hpcl"]="hpc-studies"

declare -A ports

ports["rust-lang"]="10443"
ports["java"]="10445"
ports["ccna60d"]="10444"
ports["ts"]="10447"
ports["www"]="10446"
ports["snippets"]="10448"
ports["jenkins"]="10449"
ports["hpcl"]="10450"


COMMANDS=("start" "stop" "restart" "monitor" "status")
OPTIONS=("all")
for name in ${!dirs[@]}; do OPTIONS=(${OPTIONS[@]} "${name}"); done


dir_name=`/usr/bin/dirname $LOG_FILE`
if [ ! -d "${dirname}" ]; then /usr/bin/mkdir -p $dir_name; fi
if [ ! -f "${LOG_FILE}" ]; then touch $LOG_FILE; fi

stop_srv() {
    proc_num=`/usr/bin/netstat -ntlp 2> /dev/null | grep "${ports[$1]}" | wc -l`
    if [ $proc_num -ne 0 ]; then
        echo -e "\n\rStopping $1 ..."
        kill `/usr/bin/netstat -ntlp 2> /dev/null | grep ${ports[$1]} | awk -F' ' '{print $7}' | awk -F'/' '{print $1}'`
        sleep 3
    fi
}

gen_sitemap() {
    echo -e "\r\nGenerating $1 sitemap.xml..."
    if [ ! -f "book/sitemap.xml" ]; then
        mdbook-sitemap-generator -d "$1.xfoss.com" -o book/sitemap.xml
        /usr/bin/sed -i '1 i\<?xml version="1.0" encoding="utf-8" ?>' book/sitemap.xml
        /usr/bin/sed -i 's/\.md/\.html/g' book/sitemap.xml
        /usr/bin/sed -i 's/<loc>/<loc>https:\/\//g' book/sitemap.xml
        /usr/bin/sed -i 's/<urlset>/<urlset xmlns=\"http:\/\/www.sitemaps.org\/schemas\/sitemap\/0.9\">/g' book/sitemap.xml
    fi
}

start_srv() {
    proc_num=`/usr/bin/netstat -ntlp 2> /dev/null | grep "${ports[$1]}" | wc -l`

    if [ $proc_num -ne 1 ]; then
        cd "$HOME/${dirs[$1]}"
        echo -e "\n\rStarting $1 ..."
        mdbook serve . -p "${ports[$1]}" -n 127.0.0.1 > /dev/null 2>&1 &
    fi
}

start_all() {
    for name in ${!dirs[@]}; do start_srv $name; done
}

kill_all() {
    echo -e "\n\rStopping all..."
    /usr/bin/ps -A | grep mdbook | while read -r line; do
    kill $(echo $line | awk -F' ' '{print $1}') && sleep 3
done
}

get_status() {
    echo "---------------------------------------------"
    echo -e " ${INFO_CLR}$1.xfoss.com${END_CLR} 状态:"
    pid=$(/usr/bin/netstat -ntlp 2> /dev/null | grep ${ports[$1]} | awk -F' ' '{print $7}' | awk -F'/' '{print $1}')

    re='^[0-9]+$'
    if ! [[ $pid =~ $re ]] ; then echo -e "${ALERT_CLR}----- Dead !!!!!!!${END_CLR}"
    else
        echo -n -e "${SUCESS_CLR}"
        /usr/bin/ps -p $pid -o pid,vsz=MEMORY -o etime=ELAPSED_TIME -o state=STATE,stime=START_TIME
        echo -n -e "${END_CLR}"
    fi
}

chk_n_restart() {
    resp_code=$(/usr/bin/curl -I "https://$1.xfoss.com/sitemap.xml" 2>/dev/null | head -n 1 | cut -d$' ' -f2)

    if [ $((`date +%s`-`git log -1 --format=%ct`)) -lt 900 ]; then
        echo -e "\r\n$1 content updated, now restarting it..." && do_restart $1;
        echo "`date` - 检查 $1 运行状态并重启服务完成" >> $LOG_FILE
        exit 0
    fi


    if [ "$resp_code" != "200" ]; then
        echo -e "\r\n$1 not running, now starting it" && start_srv $1;
    fi
}

do_mon() {
    cd "$HOME/${dirs[$1]}"

    echo -e "\r\nTrying to checkout $1 ..."

    git pull
    echo "`date` - $1 git checkout 完成" >> $LOG_FILE

    chk_n_restart $1
}

show_status() {
    case $1 in
        "all")
            for name in ${!dirs[@]}; do get_status $name; done
            ;;
        *)
            get_status $1
            ;;
    esac
}

do_start() {
    case $1 in
        "all")
            start_all
            ;;
        *)
            start_srv $1
            ;;
    esac
}

do_stop() {
    case $1 in
        "all")
            kill_all
            ;;
        *)
            stop_srv $1
            ;;
    esac
}

do_restart() {
    case $1 in
        "all")
            kill_all && start_all
            ;;
        *)
            stop_srv $1 && start_srv $1
            ;;
    esac
}


monitor() {
    case $1 in
        "all")
            for name in ${!dirs[@]}; do
                do_mon $name && exit 0
            done
            ;;
        *)
            # do_mon $1 > /dev/null 2>&1 &
            do_mon $1 && exit 0
            ;;
    esac
}
