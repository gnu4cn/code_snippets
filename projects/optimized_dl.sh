#!/usr/bin/env bash
TARGET_DIR="/home/data/测试文件"
FTP_SERVER="ftp://10.11.1.9"
CRED="xfoss-com:123456789" 

for file in $(curl -s -u "$CRED" "$FTP_SERVER" -l); do
	remote="$FTP_SERVER/$file"
	target="$TARGET_DIR/$file"

	if [ -f "$target" ]; then
		local_size=$(/usr/bin/stat -c%s "$target")

		# 这里务必要这样写，参考：https://unix.stackexchange.com/a/52806
		if /usr/bin/curl -s -L -I -u "$CRED" "$remote"  | grep -q "${local_size}"; then
			continue
		fi
	fi

	/usr/bin/curl -s -u "$CRED" "$remote" -o "$target"
done
