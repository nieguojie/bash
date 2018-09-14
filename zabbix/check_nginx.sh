#!/bin/bash
Date=`date -d "1 minute ago" |awk '{print $4}'|cut -c1-5`
Year=`date +%Y:`
num=`grep "$Year$Date" /data/log/nginx/*access.log | awk '($10 == "502") {print $0}'  | wc -l`
if [ $num -gt 2 ];then
    grep "$Year$Date" /data/log/nginx/*access.log | awk '($10 == "502") {print $0}'
fi
