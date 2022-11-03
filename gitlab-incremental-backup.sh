#!/usr/bin/env bash
LOG_FILE="/var/log/gitlab_backup.log"
COPIES_KEPT=7
BACKUP_DIR="/mnt/gitlab-backups"

handle_backup_cmd_err() {
    if [ $1 -ne 0 ]; then
        echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 备份失败，退出此程序！" >> $LOG_FILE
        exit 1
    else
        /bin/sync
        /bin/sleep 0.5

        new_backup=`/bin/ls *${substring} -t | head -n1`
        echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 备份成功：${new_backup}" >> $LOG_FILE
    fi
}

if [[ ! -f "$LOG_FILE" ]]; then touch "$LOG_FILE"; fi

cd "${BACKUP_DIR}"
echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- ----------执行 GitLab-jh 备份----------" >> $LOG_FILE

substring="_gitlab_backup.tar"
existed_copies=`/bin/ls *${substring} 2> /dev/null | wc -l`
echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 现有备份数：${existed_copies}" >> $LOG_FILE

if [[ $existed_copies == 0 ]]; then
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 无先前备份，进行完整备份......." >> $LOG_FILE
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- ----------gitlab-backup 开始运行----------" >> $LOG_FILE

    touch "$(date +%s)${substring}"
    # /bin/gitlab-backup create >> $LOG_FILE
    handle_backup_cmd_err "$?"
else 
    previous_backup=`/bin/ls *${substring} -t | head -n1`

    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 发现先前备份：${previous_backup}，采取增量备份......" >> $LOG_FILE
    echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- ----------gitlab-backup 开始运行----------" >> $LOG_FILE

    touch "$(date +%s)${substring}"
    # /bin/gitlab-backup create INCREMENTAL=yes PREVIOUS_BACKUP=${previous_backup%"$substring"} >> $LOG_FILE
    handle_backup_cmd_err "$?"

    /bin/sync && /bin/sleep 1
    
    existed_copies=`/bin/ls *${substring} | wc -l`
    while [ $existed_copies -gt $COPIES_KEPT ]; do
        oldest_copy=`/bin/ls *${substring} -t | tail -n 1`
        echo "$(date '+%Y-%m-%d, %H:%M:%S %Z') -- 现有备份数 ${existed_copies}, 超出预设 ${COPIES_KEPT}，将删除最早备份：${oldest_copy}" >> $LOG_FILE

        /bin/rm -rf "${oldest_copy}"

        /bin/sync && /bin/sleep 0.5

        existed_copies=`/bin/ls *${substring} | wc -l`
    done
fi

exit 0
