#!/usr/bin/env bash
LOCK_DIR="$HOME/.lock"
LOCK_FILE="$LOCK_DIR/rsync.lck"

BASE_DIR="$HOME/mirrors/"
SERVER="mirrors.bfsu.edu.cn"

declare -A repos
repos["epel"]="epel/7/x86_64/"
repos["base"]="centos/7.9.2009/os"
repos["sclo"]="centos/7.9.2009/sclo"

rm_lock() {
    rm -rf "${LOCK_FILE}"
}

if [ -f "${LOCK_FILE}" ]; then echo "经由 rsync 的更新已在运行......" && exit 0; fi

if ! [ -d $LOCK_DIR ]; then /usr/bin/mkdir -p $LOCK_DIR; fi
/usr/bin/touch "${LOCK_FILE}"

for name in ${!repos[@]}; do
    target_dir="${BASE_DIR}${name}"

    repo="${repos[$name]}"
    repo_url="${SERVER}/${repo}"

    if [[ -d "${target_dir}" ]]; then
        rsync  -auvzP --exclude debug --delete "rsync://${repo_url}" "${target_dir}/"
    else
        echo "${target_dir} 目录不存在:-{"
        /usr/bin/mkdir -p "${target_dir}"
        rsync  -auvzP --exclude debug --delete "rsync://${repo_url}" "${target_dir}/"
    fi

    if [[ $? -eq '0' ]]; then
        echo -e "\n${name} 同步成功......:)\n"
    else
        rm_lock && echo "同步失败:(" && exit 1
    fi
done

rm_lock && exit 0
