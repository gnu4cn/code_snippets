#!/bin/bash
LOCK_FILE="$HOME/.lock/rsync.lck"

if [ -f "${LOCK_FILE}" ]; then echo "经由 rsync 的更新已在运行......" && exit 0; fi

BASE_DIR="/var/mirrors/"
SERVER="mirrors.bfsu.edu.cn"

declare -A releases
releases["epel"]="7/x86_64/"
releases["centos"]="7.9.2009/sclo/"

declare -A GPG_KEY
GPG_KEY["epel"]="RPM-GPG-KEY-EPEL-7"
GPG_KEY["centos"]="RPM-GPG-KEY-CentOS-7"

/usr/bin/touch "${LOCK_FILE}"

rm_lock() {
    rm -rf "${LOCK_FILE}"
}

do_rsync() {
    # echo -e "\n${1}\n${2}\n${3}\n${4}"
    rsync  -auvzP --exclude debug --delete "rsync://${1}" "${2}/" && \
    rsync  -auvzP --delete "rsync://${3}" "${4}"
}

for name in ${!releases[@]}; do
    release="${releases[$name]}" 

    target_base="${BASE_DIR}${name}/"
    target_dir="${target_base}${release}" 

    base_url="${SERVER}/${name}/"
    repo_url="${base_url}${release}"
    gpg_url="${base_url}${GPG_KEY[${name}]}"

    if [[ -d "${target_dir}" ]]; then
        do_rsync "$repo_url" "${target_dir}" "${gpg_url}" "${target_base}"
    else
        echo "${target_dir} 目录不存在:-{"
        /usr/bin/mkdir -p "${target_dir}"
        do_rsync "$repo_url" "${target_dir}" "${gpg_url}" "${target_base}"
    fi

    if [[ $? -eq '0' ]]; then
        echo -e "\n${name} 同步成功......:)\n"
    else
        rm_lock && echo "同步失败:(" && exit 1
    fi
done

rm_lock && exit 0
