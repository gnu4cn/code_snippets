#!/usr/bin/env bash
LOG_FILE="/var/log/gitlab_backup.log"
COPIES_KEPT=7
BACKUP_DIR="/mnt/gitlab-backups"

handle_backup_cmd_err() {
    if [ $1 -ne 0 ]; then
        echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 备份失败，退出此程序！" >> $LOG_FILE && exit 1
    fi

    /bin/sync && /bin/sleep 0.5
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 备份成功：$(/bin/ls *${substring} -t | head -n1)" >> $LOG_FILE
}

beginning_msg_log() {
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- ----------执行 GitLab-jh 备份----------" >> $LOG_FILE

    if [ "${1}" = "" ]; then
        echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 无先前备份，进行完整备份......." >> $LOG_FILE
    else
        echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 发现先前备份：${1}，采取增量备份......" >> $LOG_FILE
    fi

    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- ----------gitlab-backup 开始运行----------" >> $LOG_FILE
}

if [ ! -d "${BACKUP_DIR}" ]; then
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- ${BACKUP_DIR} 不存在，将退出此程序！" >> $LOG_FILE && exit 1
fi

if [[ ! -f "$LOG_FILE" ]]; then touch "$LOG_FILE"; fi

cd "${BACKUP_DIR}"
substring="_gitlab_backup.tar"
if [[ $(/bin/ls *${substring} 2> /dev/null | wc -l) == 0 ]]; then
    beginning_msg_log
    /bin/gitlab-backup create >> $LOG_FILE
    handle_backup_cmd_err "$?"
    exit 0
fi

previous_backup=`/bin/ls *${substring} -t | head -n1`
beginning_msg_log "${previous_backup}"
/bin/gitlab-backup create INCREMENTAL=yes PREVIOUS_BACKUP=${previous_backup%"$substring"} >> $LOG_FILE
handle_backup_cmd_err "$?"

existed_copies=`/bin/ls *${substring} | wc -l`
while [ $existed_copies -gt $COPIES_KEPT ]; do
    oldest_copy=`/bin/ls *${substring} -t | tail -n 1`
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 现有备份数 ${existed_copies}, 超出预设 ${COPIES_KEPT}，将删除最早备份：${oldest_copy}" >> $LOG_FILE
    /bin/rm -rf "${oldest_copy}" && /bin/sync && /bin/sleep 0.5
    existed_copies=`/bin/ls *${substring} | wc -l`
done
exit 0
