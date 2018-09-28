#!/bin/bash
total=`cat /tmp/test.txt`
h1=`date +%H%M`
h2=`date +%Y%m%d -d "1 days ago"`
if [ $h1 -gt 0901 -a $h1 -lt 0904 ];then
    echo "$h2 消耗流量包大约 $total"
else
	echo
fi

