#!/bin/bash
ps -ef | grep inotify | grep -v grep &>/dev/null
if [ $? -ne 0 ];then
cd /usr/local/sbin;nohup /usr/bin/sh /usr/local/sbin/inotify_rsync.sh &
fi

