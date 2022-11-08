#!/usr/bin/env bash
LOG_FILE="/var/log/gitlab_backup.log"
COPIES_KEPT=7
BACKUP_DIR="/mnt/gitlab-backups"
SUBSTRING="_gitlab_backup.tar"

handle_backup_cmd_err() {
    if [ $1 -ne 0 ]; then
        echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 备份失败，退出此程序！" >> $LOG_FILE && exit 1
    fi

    /bin/sync && /bin/sleep 0.5
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 备份成功：$(/bin/ls *${SUBSTRING} -t | head -n1)" >> $LOG_FILE
}

beginning_msg_log() {
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- -------------------------------------------------------------" >> $LOG_FILE
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- -------------------- 执行 GitLab-jh 备份 --------------------" >> $LOG_FILE
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- -------------------------------------------------------------" >> $LOG_FILE

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
if [[ $(/bin/ls *${SUBSTRING} 2> /dev/null | wc -l) == 0 ]]; then
    beginning_msg_log
    /bin/gitlab-backup create >> $LOG_FILE
    handle_backup_cmd_err "$?"
    exit 0
fi

previous_backup=`/bin/ls *${SUBSTRING} -t | head -n1`
beginning_msg_log "${previous_backup}"
/bin/gitlab-backup create INCREMENTAL=yes PREVIOUS_BACKUP=${previous_backup%"$SUBSTRING"} >> $LOG_FILE
handle_backup_cmd_err "$?"

while [ $(/bin/ls *${SUBSTRING} | wc -l) -gt $COPIES_KEPT ]; do
    oldest_copy=`/bin/ls *${SUBSTRING} -t | tail -n 1`
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 现有备份数超出预设，将删除最早备份：${oldest_copy}" >> $LOG_FILE
    /bin/rm -rf "${oldest_copy}" && /bin/sync && /bin/sleep 0.5
done
exit 0
